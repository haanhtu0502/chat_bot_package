import 'package:chat_bot_package/clean_architectures/data/data_source/local/preferences.dart';
import 'package:chat_bot_package/core/components/configurations/configurations.dart';
import 'package:chat_bot_package/core/components/configurations/env/env_prod.dart';
import 'package:chat_bot_package/core/dependency_injection/di.dart';
import 'package:chat_bot_package/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:chat_bot_package/chat_bot_package.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:injectable/injectable.dart'; // import từ package chính

void main() async {
  Configurations().setConfigurationValues(environmentProd);
  await initHiveBoxes();
  await configureDependencies(environment: Environment.prod);
  await Preferences.ensureInitedPreferences();
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
