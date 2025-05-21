import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:chat_bot_package/clean_architectures/data/model/chat/chat_model.dart';
import 'package:chat_bot_package/clean_architectures/data/model/conversation/conversation_model.dart';
import 'package:chat_bot_package/core/components/constant/hive_constant.dart';

@module
abstract class HiveBoxModule {
  @singleton
  Box<ChatModel> chatBox() => Hive.box(HiveConstant.chatBox);

  @singleton
  Box<ConversationModel> conversationBox() =>
      Hive.box(HiveConstant.conversationBox);
}
