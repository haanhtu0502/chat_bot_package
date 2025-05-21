import 'package:chat_bot_package/app_coordinator.dart';
import 'package:chat_bot_package/clean_architectures/domain/entities/chat/chat.dart';
import 'package:chat_bot_package/clean_architectures/domain/entities/chat/chat_status.dart';
import 'package:chat_bot_package/clean_architectures/domain/entities/chat/chat_type.dart';
import 'package:chat_bot_package/clean_architectures/domain/entities/conversation/conversation.dart';
import 'package:chat_bot_package/clean_architectures/presentation/chat_bot/bloc/chat_bloc.dart';
import 'package:chat_bot_package/clean_architectures/presentation/chat_bot/bloc/chat_modal_state.dart';
import 'package:chat_bot_package/clean_architectures/presentation/chat_bot/dummy/default_question_data.dart';
import 'package:chat_bot_package/clean_architectures/presentation/chat_bot/views/chat_bot_view.dart';
import 'package:chat_bot_package/clean_architectures/presentation/chat_bot/views/widgets/build_default_question.dart';
import 'package:chat_bot_package/clean_architectures/presentation/chat_bot/views/widgets/build_icon_button.dart';
import 'package:chat_bot_package/clean_architectures/presentation/chat_bot/views/widgets/gradient_text.dart';
import 'package:chat_bot_package/clean_architectures/presentation/chat_bot/views/widgets/listening_icon.dart';
import 'package:chat_bot_package/clean_architectures/presentation/chat_bot/views/widgets/message_item.dart';
import 'package:chat_bot_package/clean_architectures/presentation/conversation/bloc/conversation_bloc.dart';
import 'package:chat_bot_package/clean_architectures/presentation/conversation/views/conversation_view.dart';
import 'package:chat_bot_package/core/components/configurations/open_ai_api_config.dart';
import 'package:chat_bot_package/core/components/constant/image_const.dart';
import 'package:chat_bot_package/core/components/extensions/context_extensions.dart';
import 'package:chat_bot_package/core/components/extensions/string_extensions.dart';
import 'package:chat_bot_package/core/components/widgets/loading_page.dart';
import 'package:chat_bot_package/core/design_systems/theme_colors.dart';
import 'package:chat_bot_package/core/services/open_ai_service.dart';
import 'package:chat_bot_package/core/services/stream/stream_mixin.dart';
import 'package:chat_bot_package/localization/chat_bot_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBotMobile extends StatefulWidget {
  final TextEditingController textController;
  final Function(BuildContext, ChatState) listenChatState;
  final Function(BuildContext, ConversationState) listenConversationStateChange;
  final Function(Chat) handleSpeechText;
  final String? userName;
  final List<String>? defaultQuestions;
  final Widget? closeIcon;
  final void Function()? onClose;
  final bool isShowBackButton;
  final bool isShowMenuButton;

  const ChatBotMobile({
    super.key,
    required this.textController,
    required this.listenConversationStateChange,
    required this.handleSpeechText,
    required this.listenChatState,
    this.userName,
    this.defaultQuestions,
    this.closeIcon,
    this.onClose,
    this.isShowBackButton = true,
    this.isShowMenuButton = true,
  });

  @override
  State<ChatBotMobile> createState() => _ChatBotMobileState();
}

class _ChatBotMobileState extends State<ChatBotMobile> with OpenAiService {
  final ValueNotifier<bool> _enableSendButton = ValueNotifier(false);
  ChatBloc get _bloc => context.read<ChatBloc>();

  ConversationBloc get _conversationBloc => context.read<ConversationBloc>();

  ChatState get _state => _bloc.state;

  ChatModalState get _data => _bloc.data;

  bool get _micAvailable => _data.micAvailable;

  List<Chat> get _chats => _data.chats;

  Conversation? get _conversation => _data.conversation;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ChatBotConfig get _chatConfig => ChatBotConfig();

  ///Open Ai service
  @override
  String get apiKey => _chatConfig.getApiKey;

  @override
  String get assistantId => _chatConfig.getAssistantId;

  @override
  String get threadId => _conversation?.threadId ?? "";

  void _pop() {
    if (_chats.isNotEmpty) {
      context.popArgs(
        MessageReturn(
            title: _chats.last.title.toHeaderConversation,
            lastMessage: _chats.first.title),
      );
    } else {
      context.pop();
    }
  }

  @override
  void sendChatCompleted(String? newContent, String? chatId) {
    if (chatId != null) {
      _bloc.add(ChatEvent.updateChatByNewText(newContent ?? "", chatId));
    }
  }

  @override
  void initState() {
    super.initState();
    ChatBotLocalizations.loadTranslations().then((_) {
      setState(() {});
    });
    if (_chatConfig.isStreamResponse) {
      initService();
    }
  }

  void _onSendMessage() {
    if (_chatConfig.isStreamResponse) {
      if (!isStreamWorking) {
        _bloc.add(ChatEvent.addEmptyChat(widget.textController.text));
      }
    } else {
      _enableSendButton.value = false;

      _bloc.add(ChatEvent.sendChat(widget.textController.text));
    }
    widget.textController.clear();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<ChatBloc, ChatState>(listener: (_, state) {
        widget.listenChatState(_, state);
        state.maybeWhen(
          addEmptyChatState: (_, message) {
            onSendMessage(message,
                newThreadId: state.data.conversation?.threadId);
          },
          orElse: () {},
        );
      }, builder: (context, state) {
        return Stack(
          children: [
            _body(context, state: state),
            if (state.loading)
              Container(
                color: Colors.black45,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: StyleLoadingWidget.foldingCube.renderWidget(
                      size: 40.0, color: Theme.of(context).primaryColor),
                ),
              )
          ],
        );
      }),
    );
  }

  Widget _body(BuildContext context, {required ChatState state}) {
    return BlocListener<ConversationBloc, ConversationState>(
      bloc: _conversationBloc,
      listener: widget.listenConversationStateChange,
      child: Scaffold(
        key: _scaffoldKey,
        extendBody: true,
        endDrawer: const Drawer(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ConversationView(isWebPlatform: true),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            children: [
              if (widget.isShowBackButton || widget.isShowMenuButton)
                Row(
                  children: [
                    widget.isShowBackButton
                        ? InkWell(
                            onTap: () {
                              if (widget.onClose != null) {
                                widget.onClose!();
                              } else {
                                Navigator.of(context).pop();
                              }
                            },
                            child: widget.closeIcon ??
                                const Icon(
                                  Icons.arrow_back,
                                ),
                          )
                        : const SizedBox(),
                    const Spacer(),
                    widget.isShowMenuButton
                        ? InkWell(
                            onTap: () {
                              _scaffoldKey.currentState?.openEndDrawer();
                            },
                            child: const Icon(Icons.menu),
                          )
                        : const SizedBox(),
                  ],
                ),
              const SizedBox(height: 16),
              _buildChatContent(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatContent(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          if (_conversation != null) ...[
            _chats.isEmpty
                ? _chatContentNoHistory(context)
                : _chatContentWithHistory(context),
            _buildChatBox(context),
          ] else ...[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(ImageConst.appIcon,
                          width: 32.0, height: 32.0, fit: BoxFit.cover),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    ChatBotLocalizations.of(
                        context, "pleaseCreateNewConversation"),
                    textAlign: TextAlign.center,
                    style: context.titleMedium
                        .copyWith(fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _chatContentWithHistory(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        reverse: false,
        itemCount: _chats.length,
        itemBuilder: (_, index) {
          final chat = _chats[index];
          if (_chatConfig.isStreamResponse && (index == _chats.length - 1)) {
            return buildTextResponseWidget((isLoadingStream, isStreamWorking) {
              return ValueListenableBuilder(
                valueListenable: textResponse,
                builder: (_, streamTextResponse, __) {
                  return _messageItem(context,
                      chat: chat,
                      isLoadingStream: false,
                      isStreamWorking: isStreamWorking,
                      streamTextResponse: streamTextResponse);
                },
              );
            });
          }
          return _messageItem(context, chat: chat);
        },
      ),
    );
  }

  Widget _messageItem(
    BuildContext context, {
    required Chat chat,
    bool? isLoadingStream,
    bool? isStreamWorking,
    String? streamTextResponse,
  }) {
    return MessageItem(
      content: chat.title,
      loading: isLoadingStream ?? chat.chatStatus.isLoading,
      time: chat.createdAt,
      isBot: chat.chatType.isAssistant,
      isErrorMessage: chat.chatStatus.isError,
      speechOnPress: () => widget.handleSpeechText(chat),
      longPressText: () {},
      isAnimatedText: false,
      textAnimationCompleted: () =>
          _bloc.add(const ChatEvent.changeTextAnimation(false)),
      isStreamWorking: isStreamWorking,
      streamTextResponse: streamTextResponse,
    );
  }

  Widget _chatContentNoHistory(BuildContext context) {
    var listQuestion = widget.defaultQuestions ?? defaultQuestionData;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            ImageConst.chatBotPng,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 8),
          GradientText(
            text:
                '${ChatBotLocalizations.of(context, "hello")} ${widget.userName ?? ''}!',
            style: context.titleLargeS20.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            ChatBotLocalizations.of(context, "whatCanIHelpYou"),
            style: context.titleLargeS20.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 18),
          ...listQuestion
              .map(
                (e) => BuildDefaultQuestion(
                  question: e,
                  onTap: () {
                    _bloc.add(ChatEvent.sendChat(e));
                  },
                ),
              )
              .toList()
              .expand(
                (element) => [
                  element,
                  const SizedBox(height: 8),
                ],
              ),
        ],
      ),
    );
  }

  Widget _buildChatBox(BuildContext context) {
    final micIcon =
        !_micAvailable ? CupertinoIcons.mic_off : CupertinoIcons.mic_fill;
    return Container(
      padding: const EdgeInsets.all(1), // Độ dày border
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          transform:
              GradientRotation(136.1 * 3.1416 / 180), // chuyển deg -> rad
          colors: [
            Color(0xFF36DFF1),
            Color(0xFF2764E7),
          ],
          stops: [0.1131, 0.8169],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 12,
        ), // nội dung bên trong
        decoration: BoxDecoration(
          color: Colors.white, // nền bên trong
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                _enableSendButton.value = value.isNotEmpty;
              },
              onSubmitted: (value) {
                _onSendMessage();
              },
              controller: widget.textController,
              decoration: InputDecoration(
                hintText: _state.listenSpeech
                    ? ChatBotLocalizations.of(context, "listening")
                    : ChatBotLocalizations.of(context, "askMsSunny"),
                border: InputBorder.none,
                hintStyle: context.titleMedium.copyWith(
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: !_state.listenSpeech
                      ? () => _bloc.add(const ChatEvent.startListenSpeech())
                      : () => _bloc.add(const ChatEvent.stopListenSpeech()),
                  icon: _state.listenSpeech
                      ? const ListeningIcon()
                      : Icon(micIcon, color: Theme.of(context).hintColor),
                ),
                ValueListenableBuilder(
                  valueListenable: _enableSendButton,
                  builder: (context, value, child) {
                    return BuildIconButton(
                      onTap: () {
                        if (!_enableSendButton.value) return;
                        _onSendMessage();
                      },
                      assetIcon: ImageConst.sendIcon,
                      isActive: _enableSendButton.value,
                      activeIconColor: Colors.white,
                      activeBackgroundColor: AppColors.brightBlue.toColor(),
                      inactiveIconColor: const Color.fromRGBO(187, 187, 187, 1),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
