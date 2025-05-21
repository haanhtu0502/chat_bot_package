import 'dart:io';
import 'package:chat_bot_package/clean_architectures/data/data_source/remote/utils/data_state.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/dio.dart';

import 'utils/app_failure.dart';

abstract class BaseApi {
  final String dataNullError = "Data null";
  final String baseError = "Error";

  Future<DataState<T>> getStateOf<T>({
    required Future<HttpResponse<T>> Function() request,
  }) async {
    try {
      final httpResponse = await request();

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(data: httpResponse.data);
      } else {
        return DataFailed(
          // ignore: deprecated_member_use
          dioError: DioError(
            requestOptions: httpResponse.response.requestOptions,
            response: httpResponse.response,
          ),
        );
      }
      // ignore: deprecated_member_use
    } on DioError catch (error) {
      return DataFailed(
          dioError: error,
          appFailure: AppFailure.fromCode(error.response?.statusCode ?? 0));
    }
  }
}
