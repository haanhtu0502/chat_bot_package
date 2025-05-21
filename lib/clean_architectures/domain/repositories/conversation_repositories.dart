import 'package:chat_bot_package/clean_architectures/data/model/chat/create_thread_response.dart';
import 'package:chat_bot_package/clean_architectures/domain/entities/conversation/conversation.dart';
import 'package:chat_bot_package/core/components/network/app_exception.dart';

abstract class ConversationRepositories {
  Future<SResult<List<Conversation>>> getConversations();
  Future<SResult<Conversation>> createdConversation({required String threadId});
  Future<SResult<Conversation>> updateConversation(
      Conversation newConversation);
  Future<SResult<bool>> deleteConversation(int conversationId);
  Future<SResult<Conversation>> getConversationById(int conversationId);
  Future<SResult<CreateThreadResponse>> createThread();
  Future<SResult> deleteThread(String threadId);
}
