import 'package:chat_bot_package/clean_architectures/domain/entities/chat/chat.dart';
import 'package:chat_bot_package/clean_architectures/domain/entities/conversation/conversation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_modal_state.freezed.dart';

@freezed
class ChatModalState with _$ChatModalState {
  const factory ChatModalState({
    required List<Chat> chats,
    Conversation? conversation,
    String? messageId,
    @Default(false) bool micAvailable,
    @Default(false) bool textAnimation,
  }) = _ChatModalState;
}
