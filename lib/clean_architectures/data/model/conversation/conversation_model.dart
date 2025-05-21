import 'package:chat_bot_package/clean_architectures/domain/entities/conversation/conversation.dart';
import 'package:chat_bot_package/core/components/constant/hive_constant.dart';
import 'package:hive/hive.dart';

part 'conversation_model.g.dart';

@HiveType(typeId: HiveConstant.conversationHiveId)
class ConversationModel extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  int createdAt;

  @HiveField(2)
  String? header;

  @HiveField(3)
  String? title;

  @HiveField(4)
  String? lastMessage;

  @HiveField(5)
  int? lastUpdate;

  @HiveField(6)
  String? threadId;

  ConversationModel({
    required this.id,
    required this.createdAt,
    this.header,
    this.threadId,
    this.title,
    this.lastMessage,
    this.lastUpdate,
  });

  Conversation get toEntity => Conversation(
        id: id,
        createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
        header: header ?? "Ms.Sunny",
        title: title ?? "",
        threadId: threadId ?? "",
        lastMessage: lastMessage,
        lastUpdate: DateTime.fromMillisecondsSinceEpoch(lastUpdate ?? 0),
      );
}
