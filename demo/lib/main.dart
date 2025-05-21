import 'package:chat_bot_package/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:chat_bot_package/chat_bot_package.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  runApp(const ChatBotExampleApp());
}

class ChatBotExampleApp extends StatelessWidget {
  const ChatBotExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Bot Package Demo',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        ChatBotLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: ChatBotLocalizations.delegate.supportedLocales,
      home: const ChatBotWrapper(), // widget từ package
    );
  }
}
