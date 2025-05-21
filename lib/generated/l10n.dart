// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class ChatBotLocalizations {
  ChatBotLocalizations();

  static ChatBotLocalizations? _current;

  static ChatBotLocalizations get current {
    assert(_current != null,
        'No instance of ChatBotLocalizations was loaded. Try to initialize the ChatBotLocalizations delegate before accessing ChatBotLocalizations.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<ChatBotLocalizations> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = ChatBotLocalizations();
      ChatBotLocalizations._current = instance;

      return instance;
    });
  }

  static ChatBotLocalizations of(BuildContext context) {
    final instance = ChatBotLocalizations.maybeOf(context);
    assert(instance != null,
        'No instance of ChatBotLocalizations present in the widget tree. Did you add ChatBotLocalizations.delegate in localizationsDelegates?');
    return instance!;
  }

  static ChatBotLocalizations? maybeOf(BuildContext context) {
    return Localizations.of<ChatBotLocalizations>(
        context, ChatBotLocalizations);
  }

  /// `update`
  String get update {
    return Intl.message(
      'update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `See more`
  String get seeMore {
    return Intl.message(
      'See more',
      name: 'seeMore',
      desc: '',
      args: [],
    );
  }

  /// `Sort By`
  String get sortBy {
    return Intl.message(
      'Sort By',
      name: 'sortBy',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Languages`
  String get languages {
    return Intl.message(
      'Languages',
      name: 'languages',
      desc: '',
      args: [],
    );
  }

  /// `Currencies`
  String get currencies {
    return Intl.message(
      'Currencies',
      name: 'currencies',
      desc: '',
      args: [],
    );
  }

  /// `Appearance`
  String get appearance {
    return Intl.message(
      'Appearance',
      name: 'appearance',
      desc: '',
      args: [],
    );
  }

  /// `Log in`
  String get logIn {
    return Intl.message(
      'Log in',
      name: 'logIn',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get logOut {
    return Intl.message(
      'Log out',
      name: 'logOut',
      desc: '',
      args: [],
    );
  }

  /// `Dark theme`
  String get darkTheme {
    return Intl.message(
      'Dark theme',
      name: 'darkTheme',
      desc: '',
      args: [],
    );
  }

  /// `Light theme`
  String get lightTheme {
    return Intl.message(
      'Light theme',
      name: 'lightTheme',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Code and fingerprint`
  String get codeAndFingerPrints {
    return Intl.message(
      'Code and fingerprint',
      name: 'codeAndFingerPrints',
      desc: '',
      args: [],
    );
  }

  /// `Lock and Security`
  String get lockAndSecurity {
    return Intl.message(
      'Lock and Security',
      name: 'lockAndSecurity',
      desc: '',
      args: [],
    );
  }

  /// `General settings`
  String get generalSettings {
    return Intl.message(
      'General settings',
      name: 'generalSettings',
      desc: '',
      args: [],
    );
  }

  /// `By Price`
  String get byPrice {
    return Intl.message(
      'By Price',
      name: 'byPrice',
      desc: '',
      args: [],
    );
  }

  /// `Enter code`
  String get enterCode {
    return Intl.message(
      'Enter code',
      name: 'enterCode',
      desc: '',
      args: [],
    );
  }

  /// `Error code`
  String get errorCode {
    return Intl.message(
      'Error code',
      name: 'errorCode',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get about {
    return Intl.message(
      'About',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `Input your API Key`
  String get inputYourApiKey {
    return Intl.message(
      'Input your API Key',
      name: 'inputYourApiKey',
      desc: '',
      args: [],
    );
  }

  /// `I'm just starting out with my fitness journey and would like a suitable workout plan based on my goals and fitness level. Can you help me create an effective fitness routine?`
  String get prompt1 {
    return Intl.message(
      'I\'m just starting out with my fitness journey and would like a suitable workout plan based on my goals and fitness level. Can you help me create an effective fitness routine?',
      name: 'prompt1',
      desc: '',
      args: [],
    );
  }

  /// `I want to lose weight and improve my overall health. Can you provide guidance on the appropriate diet and exercise schedule to help me achieve this?`
  String get prompt2 {
    return Intl.message(
      'I want to lose weight and improve my overall health. Can you provide guidance on the appropriate diet and exercise schedule to help me achieve this?',
      name: 'prompt2',
      desc: '',
      args: [],
    );
  }

  /// `I'm having trouble performing a specific exercise and want to ensure that I'm using the correct technique. Can you guide me on the proper form and how to correct any mistakes?`
  String get prompt3 {
    return Intl.message(
      'I\'m having trouble performing a specific exercise and want to ensure that I\'m using the correct technique. Can you guide me on the proper form and how to correct any mistakes?',
      name: 'prompt3',
      desc: '',
      args: [],
    );
  }

  /// `I'm looking to increase my strength and muscle tone. Can you recommend effective exercises and methods for muscle building?`
  String get prompt4 {
    return Intl.message(
      'I\'m looking to increase my strength and muscle tone. Can you recommend effective exercises and methods for muscle building?',
      name: 'prompt4',
      desc: '',
      args: [],
    );
  }

  /// `I'm planning to participate in a fitness competition and need a tailored workout and nutrition plan to prepare for it. Can you assist me in developing a plan and provide in-depth advice?`
  String get prompt5 {
    return Intl.message(
      'I\'m planning to participate in a fitness competition and need a tailored workout and nutrition plan to prepare for it. Can you assist me in developing a plan and provide in-depth advice?',
      name: 'prompt5',
      desc: '',
      args: [],
    );
  }

  /// `I've experienced an injury during my training and would like to know how to recover quickly and safely. Can you guide me on recovery methods and injury treatment?`
  String get prompt6 {
    return Intl.message(
      'I\'ve experienced an injury during my training and would like to know how to recover quickly and safely. Can you guide me on recovery methods and injury treatment?',
      name: 'prompt6',
      desc: '',
      args: [],
    );
  }

  /// `I want to improve my cardiovascular endurance and stamina. Can you help me establish an effective cardio workout plan and provide advice on increasing endurance?`
  String get prompt7 {
    return Intl.message(
      'I want to improve my cardiovascular endurance and stamina. Can you help me establish an effective cardio workout plan and provide advice on increasing endurance?',
      name: 'prompt7',
      desc: '',
      args: [],
    );
  }

  /// `I'm interested in exploring new fitness methods such as yoga, pilates, or swimming. Can you provide information and guidance on these techniques?`
  String get prompt8 {
    return Intl.message(
      'I\'m interested in exploring new fitness methods such as yoga, pilates, or swimming. Can you provide information and guidance on these techniques?',
      name: 'prompt8',
      desc: '',
      args: [],
    );
  }

  /// `I want to understand the role of nutrition in achieving my fitness goals. Can you advise me on proper nutrition and a suitable eating plan?`
  String get prompt9 {
    return Intl.message(
      'I want to understand the role of nutrition in achieving my fitness goals. Can you advise me on proper nutrition and a suitable eating plan?',
      name: 'prompt9',
      desc: '',
      args: [],
    );
  }

  /// `I'm feeling demotivated and would like to know how to maintain motivation throughout my fitness journey. Can you provide strategies and advice to help me stay on track and reach my goals?`
  String get prompt10 {
    return Intl.message(
      'I\'m feeling demotivated and would like to know how to maintain motivation throughout my fitness journey. Can you provide strategies and advice to help me stay on track and reach my goals?',
      name: 'prompt10',
      desc: '',
      args: [],
    );
  }

  /// `Ask Ms.Sunny`
  String get askMsSunny {
    return Intl.message(
      'Ask Ms.Sunny',
      name: 'askMsSunny',
      desc: '',
      args: [],
    );
  }

  /// `Listening...`
  String get listening {
    return Intl.message(
      'Listening...',
      name: 'listening',
      desc: '',
      args: [],
    );
  }

  /// `What can I help you with`
  String get whatCanIHelpYou {
    return Intl.message(
      'What can I help you with',
      name: 'whatCanIHelpYou',
      desc: '',
      args: [],
    );
  }

  /// `Hello`
  String get hello {
    return Intl.message(
      'Hello',
      name: 'hello',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get history {
    return Intl.message(
      'History',
      name: 'history',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get today {
    return Intl.message(
      'Today',
      name: 'today',
      desc: '',
      args: [],
    );
  }

  /// `Last 7 days`
  String get last7Days {
    return Intl.message(
      'Last 7 days',
      name: 'last7Days',
      desc: '',
      args: [],
    );
  }

  /// `You have no messages`
  String get youHaveNoMessage {
    return Intl.message(
      'You have no messages',
      name: 'youHaveNoMessage',
      desc: '',
      args: [],
    );
  }

  /// `New chat`
  String get newChat {
    return Intl.message(
      'New chat',
      name: 'newChat',
      desc: '',
      args: [],
    );
  }

  /// `Delete conversation`
  String get deleteConversation {
    return Intl.message(
      'Delete conversation',
      name: 'deleteConversation',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this conversation?`
  String get confirmDeleteConversation {
    return Intl.message(
      'Are you sure you want to delete this conversation?',
      name: 'confirmDeleteConversation',
      desc: '',
      args: [],
    );
  }

  /// `Please create a new conversation`
  String get pleaseCreateNewConversation {
    return Intl.message(
      'Please create a new conversation',
      name: 'pleaseCreateNewConversation',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate
    extends LocalizationsDelegate<ChatBotLocalizations> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'vi'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<ChatBotLocalizations> load(Locale locale) =>
      ChatBotLocalizations.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
