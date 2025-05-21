import 'package:chat_bot_package/clean_architectures/data/data_source/local/preferences.dart';
import 'package:chat_bot_package/clean_architectures/data/model/chat/chat_model.dart';
import 'package:chat_bot_package/clean_architectures/data/model/conversation/conversation_model.dart';
import 'package:chat_bot_package/core/components/configurations/configurations.dart';
import 'package:chat_bot_package/core/components/configurations/env/env_prod.dart';
import 'package:chat_bot_package/core/components/configurations/open_ai_api_config.dart';
import 'package:chat_bot_package/core/components/constant/hive_constant.dart';
import 'package:chat_bot_package/core/dependency_injection/di.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

export 'clean_architectures/presentation/chat_bot/views/chat_bot_view.dart';
export 'clean_architectures/presentation/chat_bot_wrapper.dart';

Future<void> initChatBotConfig({
  required String apiKey,
  required String assistantId,
  String? model,
  String? turboModel,
  bool streamResponse = false,

  ///Run text display
  bool runTextDisplay = false,

  /// Milliseconds
  int durations = 10,
}) async {
  Configurations().setConfigurationValues(environmentProd);
  ChatBotConfig().setConfig(
    apiKey: apiKey,
    assistantId: assistantId,
    model: model ?? "gpt-4o-mini",
    turboModel: turboModel ?? "gpt-3.5-turbo",
    isStreamResponse: streamResponse,
    runTextDisplay: runTextDisplay,
    durations: durations,
  );
  await initHiveBoxes();
  await configureDependencies(environment: Environment.prod);
  await Preferences.ensureInitedPreferences();
}

const String _hiveCached = "hiveCached";

Future<void> initHiveBoxes() async {
  Hive.registerAdapter(ChatModelAdapter());
  Hive.registerAdapter(ConversationModelAdapter());

  await Hive.openBox<dynamic>(_hiveCached);
  await Hive.openBox<ChatModel>(HiveConstant.chatBox);
  await Hive.openBox<ConversationModel>(HiveConstant.conversationBox);
}
