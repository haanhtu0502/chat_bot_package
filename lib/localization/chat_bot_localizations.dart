import 'package:chat_bot_package/localization/en.dart';
import 'package:chat_bot_package/localization/vi.dart';
import 'package:flutter/widgets.dart';

class ChatBotLocalizations {
  // Danh sách locale được hỗ trợ
  static const supportedLocales = [
    Locale('en'),
    Locale('vi'),
  ];

  static Map<String, Map<String, String>> _translations = {};

  static Future<void> loadTranslations() async {
    try {
      const enJson = en;

      final enTranslations = <String, String>{};
      enJson.forEach((key, value) {
        if (!key.startsWith('@')) {
          enTranslations[key] = value.toString();
        }
      });

      const viJson = vi;
      final viTranslations = <String, String>{};
      viJson.forEach((key, value) {
        if (!key.startsWith('@')) {
          viTranslations[key] = value.toString();
        }
      });

      _translations = {
        'en': enTranslations,
        'vi': viTranslations,
      };
    } catch (e) {
      print('Error loading translations: $e');
    }
  }

  // Hàm lấy chuỗi dịch
  static String translate(String key, Locale locale) {
    final languageCode =
        supportedLocales.contains(locale) ? locale.languageCode : 'en';
    return _translations[languageCode]?[key] ?? key;
  }

  // Hàm để sử dụng trong widget
  static String of(BuildContext context, String key) {
    return translate(key, Localizations.localeOf(context));
  }
}
