import 'package:chat_bot_package/clean_architectures/presentation/chat_bot/bloc/chat_bloc.dart';
import 'package:chat_bot_package/clean_architectures/presentation/chat_bot/views/chat_bot_view.dart';
import 'package:chat_bot_package/clean_architectures/presentation/conversation/bloc/conversation_bloc.dart';
import 'package:chat_bot_package/core/dependency_injection/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBotWrapper extends StatelessWidget {
  const ChatBotWrapper({
    super.key,
    this.userName,
    this.defaultQuestions,
    this.closeIcon,
    this.onClose,
    this.isShowBackButton = true,
    this.isShowMenuButton = true,
  });

  final String? userName;
  final List<String>? defaultQuestions;
  final Widget? closeIcon;
  final void Function()? onClose;
  final bool isShowBackButton;
  final bool isShowMenuButton;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => injector.get<ChatBloc>()),
        BlocProvider(create: (_) => injector.get<ConversationBloc>()),
      ],
      child: ChatBotView(
        userName: userName,
        defaultQuestions: defaultQuestions,
        closeIcon: closeIcon,
        onClose: onClose,
        isShowBackButton: isShowBackButton,
        isShowMenuButton: isShowMenuButton,
      ),
    );
  }
}
