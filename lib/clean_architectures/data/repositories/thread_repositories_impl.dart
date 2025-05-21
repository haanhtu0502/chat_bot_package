import 'package:chat_bot_package/clean_architectures/data/data_source/remote/base_api.dart';
import 'package:chat_bot_package/clean_architectures/data/data_source/remote/thread_api.dart';
import 'package:chat_bot_package/clean_architectures/data/data_source/remote/utils/data_state.dart';
import 'package:chat_bot_package/clean_architectures/data/data_source/remote/gpt_api.dart';
import 'package:chat_bot_package/clean_architectures/domain/entities/chat/chat_type.dart';
import 'package:chat_bot_package/clean_architectures/domain/entities/thread/thread_chat.dart';
import 'package:chat_bot_package/clean_architectures/domain/repositories/thread_repositories.dart';
import 'package:chat_bot_package/core/components/network/app_exception.dart';
import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ThreadRepositories)
class ThreadRepositoriesImpl extends BaseApi implements ThreadRepositories {
  final GPTApi _api;
  final ThreadApi _threadApi;

  ThreadRepositoriesImpl(this._api, this._threadApi);

  @override
  Future<SResult<List<ThreadChat>>> getThreadMessages(
      {required String threadId, int? limit}) async {
    var queries = <String, dynamic>{};
    if (limit != null) {
      queries = {"limit": limit};
    }
    final response = await _api.threadMessages(threadId, queries);
    if (response is DataFailed) {
      return Left(AppException(
          message: (response as DataFailed).dioError?.message ?? baseError));
    }
    return Right(response.data?.data?.map((e) => e.toEntity()).toList() ??
        <ThreadChat>[]);
  }

  @override
  Future<SResult> runThread(
      {required String threadId, String? asssistantId}) async {
    var body = <String, dynamic>{"stream": true};
    if (asssistantId != null) {
      body["assistant_id"] = asssistantId;
    }
    final response = await getStateOf(
        request: () async => await _api.threadRuns(threadId, body));

    if (response is DataFailed) {
      return Left(
          AppException(message: response.dioError?.message ?? baseError));
    }
    return const Right(dynamic);
  }

  @override
  Future<SResult> sendThreadMessage(
      {required String threadId,
      required String content,
      required ChatType type}) async {
    var queries = <String, dynamic>{
      "role": type.toTypeString,
      "content": [
        {"type": "text", "text": content}
      ]
    };
    final response = await getStateOf(
        request: () async => await _api.sendThreadMessage(threadId, queries));

    if (response is DataFailed) {
      return Left(
          AppException(message: response.dioError?.message ?? baseError));
    }
    return const Right(dynamic);
  }

  @override
  void testRunThread({required String threadId, String? asssistantId}) {
    var body = <String, dynamic>{"stream": true};
    if (asssistantId != null) {
      body["assistant_id"] = asssistantId;
    }
    _threadApi.runThreads(threadId: threadId, body: body);
  }
}
