import 'dart:developer';

// import 'package:dbiz_chat_bot_sdk/clean_architectures/data/data_source/remote/thread_api.dart';
import 'package:chat_bot_package/clean_architectures/domain/entities/chat/chat.dart';
import 'package:chat_bot_package/clean_architectures/domain/entities/conversation/conversation.dart';
import 'package:chat_bot_package/clean_architectures/presentation/chat_bot/bloc/chat_bloc.dart';
import 'package:chat_bot_package/clean_architectures/presentation/chat_bot/bloc/chat_modal_state.dart';
import 'package:chat_bot_package/clean_architectures/presentation/chat_bot/views/medias/chat_bot_mobile.dart';
import 'package:chat_bot_package/clean_architectures/presentation/conversation/bloc/conversation_bloc.dart';
import 'package:chat_bot_package/core/components/extensions/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:chat_bot_package/app_coordinator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageReturn {
  final String title;
  final String lastMessage;

  MessageReturn({
    required this.title,
    required this.lastMessage,
  });
}

class ChatBotView extends StatefulWidget {
  const ChatBotView({
    super.key,
    this.userName,
    this.defaultQuestions,
    this.closeIcon,
    this.onClose,
    this.isShowBackButton = true,
    this.isShowMenuButton = true,
    this.isOneLineTextField = false,
  });

  final String? userName;
  final List<String>? defaultQuestions;
  final Widget? closeIcon;
  final void Function()? onClose;
  final bool isShowBackButton;
  final bool isShowMenuButton;
  final bool isOneLineTextField;

  @override
  State<ChatBotView> createState() => _ChatBotViewState();
}

class _ChatBotViewState extends State<ChatBotView> {
  ChatBloc get _bloc => context.read<ChatBloc>();
  ConversationBloc get _conversationBloc => context.read<ConversationBloc>();

  ChatState get _state => _bloc.state;

  ChatModalState get _data => _bloc.data;

  List<Chat> get _chats => _data.chats;

  Conversation? get _conversation => _data.conversation;

  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    _bloc.add(const ChatEvent.initialSpeechToTextService());
    _bloc.add(const ChatEvent.initialTextToSpeechService());
    _conversationBloc.add(const ConversationEvent.getConversation());
    // _conversationBloc.add(const ConversationEvent.createConversation());
    super.initState();
  }

  void _clearTextControllerAndSend() {
    if (_textController.text.isEmpty) return;
    final cacheText = _textController.text;
    _textController.clear();
    _bloc.add(ChatEvent.sendChat(cacheText));
  }

  void _listenStateChange(_, ChatState state) {
    state.maybeWhen(
      getConversationSuccess: (_) => _bloc.add(const ChatEvent.getChat()),
      getChatSuccess: (_) =>
          _bloc.add(const ChatEvent.changeTextAnimation(false)),
      getChatFailed: (_, error) => context.showSnackBar("🐛[Get chat] $error"),
      sendChatFailed: (_, error) =>
          context.showSnackBar("🐛[Send message] $error"),
      sendChatSuccess: (_) {
        _bloc.add(const ChatEvent.changeTextAnimation(true));
        if (_conversation != null) {
          _conversationBloc.add(
            ConversationEvent.updateConversation(
              conversationId: _conversation!.id,
              lastMessage: _chats.first.title,
              title: _chats.first.title.toHeaderConversation,
            ),
          );
        }
      },
      // stopListeningSpeech: (_) => _clearTextControllerAndSend(),
      listeningCompleted: (_) => _clearTextControllerAndSend(),
      loadingSend: (_) => _textController.clear(),
      listeningSpeech: (_, textResponse) => _textController
        ..text = textResponse
        ..selection = TextSelection.collapsed(offset: textResponse.length),
      updateTextSuccess: (_, textResponse) => _textController
        ..text = textResponse
        ..selection = TextSelection.collapsed(offset: textResponse.length),
      orElse: () {},
    );
  }

  void _listenConversationStateChange(_, ConversationState state) {
    state.maybeWhen(
      getConversationSuccess: (data) {
        log("Success");
        if (data.conversations.isNotEmpty) {
          _conversationBloc.add(ConversationEvent.selectConversation(
              conversationId: data.conversations.first.id));
        } else {
          _conversationBloc.add(const ConversationEvent.createConversation());
        }
      },
      createConversationSuccess: (data) {
        _conversationBloc.add(ConversationEvent.selectConversation(
            conversationId: data.conversations.first.id));
      },
      deleteConversationSuccess: (data) {
        if (data.conversations.isNotEmpty) {
          _bloc.add(ChatEvent.getConversation(data.conversations.first.id));
        } else {
          _bloc.add(const ChatEvent.clearConversation());
        }
      },
      deleteConversationFailed: (_, error) =>
          context.showSnackBar("🐛[Delete conversation] $error"),
      getConversationFailed: (_, error) =>
          context.showSnackBar("🐛[Get conversation] $error"),
      createConversationFailed: (_, error) =>
          context.showSnackBar("🐛[Create conversation] $error"),
      selectConversationFailed: (_) => context.apiKeyWarning(),
      selectConversationSuccess: (_, id) =>
          _bloc.add(ChatEvent.getConversation(id)),
      orElse: () {},
    );
  }

  void _handleSpeechText({required String messageId, required String content}) {
    _state.maybeWhen(
      startSpeechTextSuccess: (data) {
        _bloc.add(
          ChatEvent.cancelSpeechText(
            messageId: messageId,
            previousMessageId: data.messageId ?? "",
            functionCall: () => _bloc.add(
              ChatEvent.startSpeechText(
                  content: content, messageSpeechId: messageId),
            ),
          ),
        );
      },
      orElse: () => _bloc.add(ChatEvent.startSpeechText(
          content: content, messageSpeechId: messageId)),
    );
  }

  @override
  void deactivate() {
    _bloc.add(const ChatEvent.stopSpeechText());
    _bloc.add(const ChatEvent.stopListenSpeech());
    super.deactivate();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (context.widthDevice > kTabletWidth) {
    //   return ChatBotWeb(
    //     textController: _textController,
    //     listenChatState: _listenStateChange,
    //     listenConversationStateChange: _listenConversationStateChange,
    //     handleSpeechText: (chat) =>
    //         _handleSpeechText(messageId: chat.id, content: chat.title),
    //   );
    // }
    return ChatBotMobile(
      textController: _textController,
      listenChatState: _listenStateChange,
      listenConversationStateChange: _listenConversationStateChange,
      handleSpeechText: (chat) =>
          _handleSpeechText(messageId: chat.id, content: chat.title),
      defaultQuestions: widget.defaultQuestions,
      userName: widget.userName,
      closeIcon: widget.closeIcon,
      onClose: widget.onClose,
      isShowBackButton: widget.isShowBackButton,
      isShowMenuButton: widget.isShowMenuButton,
      isOneLineTextField: widget.isOneLineTextField,
    );
  }
}
