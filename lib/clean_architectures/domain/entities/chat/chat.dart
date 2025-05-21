import 'package:chat_bot_package/clean_architectures/domain/entities/chat/chat_status.dart';
import 'package:chat_bot_package/clean_architectures/domain/entities/chat/chat_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat.freezed.dart';

@freezed
class Chat with _$Chat {
  const factory Chat({
    required String id,
    required String conversationId,
    required String title,
    required DateTime createdAt,
    DateTime? updatedAt,
    required ChatStatus chatStatus,
    required ChatType chatType,
  }) = _Chat;
}
