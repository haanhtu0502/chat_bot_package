import 'package:chat_bot_package/clean_architectures/data/data_source/remote/base_api.dart';
import 'package:chat_bot_package/clean_architectures/data/data_source/remote/utils/data_state.dart';
import 'package:chat_bot_package/clean_architectures/data/data_source/remote/gpt_api.dart';
import 'package:chat_bot_package/clean_architectures/data/model/chat/chat_model.dart';
import 'package:chat_bot_package/clean_architectures/domain/entities/chat/chat.dart';
import 'package:chat_bot_package/clean_architectures/domain/repositories/chat_repositories.dart';
import 'package:chat_bot_package/core/components/configurations/open_ai_api_config.dart';
import 'package:chat_bot_package/core/components/network/app_exception.dart';
import 'package:either_dart/either.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ChatRepositories)
class ChatRepositoriesImpl extends BaseApi implements ChatRepositories {
  final GPTApi _gptApi;
  ChatRepositoriesImpl(this._gptApi);

  Future<Box<ChatModel>> chatBox(int conversationId) async =>
      await Hive.openBox<ChatModel>('chat_$conversationId');

  @override
  Future<SResult<List<Chat>>> getChats(int conversationId) async {
    try {
      return Right(
        (await chatBox(conversationId)).values.map((e) => e.toEntity).toList()
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt)),
      );
    } catch (error) {
      return Left(AppException(message: error.toString()));
    }
  }

  @override
  Future<SResult<String>> sendMessage(List<Chat> chats) async {
    try {
      final body = {
        "model": ChatBotConfig().getModel,
        "messages": chats.map((e) => ChatModel.fromEntity(e).toJson).toList(),
        "temperature": 0.7,
      };

      final response =
          await getStateOf(request: () async => await _gptApi.chat(body: body));
      if (response is DataFailed) {
        return Left(
            AppException(message: response.dioError?.message ?? baseError));
      }

      ///[Call api here]
      return Right(response.data["choices"][0]?["message"]["content"] ?? "");
    } catch (error) {
      return Left(AppException(message: error.toString()));
    }
  }

  @override
  Future<SResult<int>> saveMessage(
      {required int conversationId, required Chat chat}) async {
    try {
      final chatB = await chatBox(conversationId);
      final chatModel = ChatModel.fromEntity(chat);
      final id = await chatB.add(chatModel);

      chatModel.id = id;

      await chatB.put(id, chatModel);

      return Right(conversationId);
    } catch (error) {
      return Left(AppException(message: error.toString()));
    }
  }
}
