import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chat_bot_package/core/components/configurations/configurations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:retrofit/dio.dart';

import '../../../../clean_architectures/data/model/api_response.dart';
import '../../helpers/api_call_helper.dart';
import '../api_exception.dart';
import 'base_api.dart';

class DioApi extends BaseApi {
  final Dio dio;
  DioApi(this.dio);

  String get baseUrl => Configurations.baseUrl;

  @override
  Stream<T> getStream<T>({
    required String url,
    Map<String, dynamic>? queryParameters,
    ApiResponseMapper<T>? onSuccess,
    void Function(CancelToken? cancelToken)? onCancel,
  }) {
    try {
      final controller = StreamController<T>.broadcast();
      final cancleToken = CancelToken();
      final List<int> chunks = [];
      onCancel?.call(cancleToken);

      dio
          .get(
        url,
        queryParameters: queryParameters,
        cancelToken: cancleToken,
        options: Options(responseType: ResponseType.stream),
      )
          .then((value) {
        value.data?.stream.listen(
          (List<int> chunk) {
            chunks.addAll(chunk);
          },
          onDone: () {
            final rawData = utf8.decode(chunks);
            final dataList = rawData
                .split("\n")
                .where((element) => element.isNotEmpty)
                .toList();
            for (final line in dataList) {
              final data = json.decode(line);
              if (data is Map<String, dynamic>) {
                final mappedData = onSuccess?.call(data);
                if (mappedData != null) {
                  controller.sink.add(mappedData);
                }
              }
            }
          },
          onError: (err) {
            controller
              ..sink
              ..addError(err);
            controller.close();
          },
        );
      }, onError: (err) {
        controller
          ..sink
          ..addError(err);
        controller.close();
      });
      return controller.stream;
    } on DioException catch (errr) {
      throw ApiException(
        code: errr.response?.statusCode ?? 0,
        message: errr.response?.statusMessage ?? '',
      );
    }
  }

  @override
  Stream<Response> postStream({
    required String url,
    Map<String, dynamic>? request,
    void Function(CancelToken? cancelToken)? onCancel,
  }) {
    final cancelData = CancelToken();
    onCancel?.call(cancelData);

    final response = dio
        .post(
          url,
          data: json.encode(request),
          cancelToken: cancelData,
        )
        .asStream();

    return response;
  }

  ///[How to use this function]
  /// ```dart
  /// final stream = dioApi.ssePostStream(
  ///  url: 'your_url_here',
  /// request: {'param': 'value'},
  ///  onChange: (data) {
  ///   // Handle the data change here
  ///  return data;
  ///  },
  /// onSuccess: (data) {
  ///  // Handle the success here
  ///  return data;
  ///
  /// },
  /// onCancel: (cancelToken) {
  ///  // Handle the cancel token here
  ///  },
  /// );
  /// ```
  /// This function is used to send a Server-Sent Events (SSE) POST request
  @override
  Stream<List<T>?> ssePostStream<T>({
    required String url,
    Map<String, dynamic>? request,
    List<T>? Function(List<String>)? onChange,
    T? Function(Map<String, dynamic> data)? onSuccess,
    void Function(CancelToken? cancelToken)? onCancel,
    void Function()? onDone,
  }) {
    try {
      final controller = StreamController<List<T>?>.broadcast();
      final cancleToken = CancelToken();
      onCancel?.call(cancleToken);

      dio
          .post(
        url,
        data: json.encode(request),
        cancelToken: cancleToken,
        options: Options(responseType: ResponseType.stream),
      )
          .then((value) {
        (value.data?.stream as Stream).listen(
          (chunk) {
            try {
              final rawData = utf8.decode(chunk);
              final dataList = rawData
                  .split("\n")
                  .where((element) => element.isNotEmpty)
                  .toList();
              final streamResponse = onChange?.call(dataList);
              controller
                ..sink
                ..add(streamResponse);
            } catch (_) {
              // Handle the error here
            }
          },
          onDone: () {
            onSuccess?.call({});
            controller.close();
            onDone?.call();
          },
          onError: (err) {
            controller
              ..sink
              ..addError(err);
            controller.close();
          },
        );
      }, onError: (err) {
        controller
          ..sink
          ..addError(err);
        controller.close();
      });
      return controller.stream;
    } on DioException catch (errr) {
      throw ApiException(
        code: errr.response?.statusCode ?? 0,
        message: errr.response?.statusMessage ?? '',
      );
    }
  }

  @override
  Future<HttpResponse<ApiResponse<T>>> get<T>(
      {required String url,
      Map<String, dynamic>? queryParameters,
      required ApiResponseMapper<T> mapper}) async {
    const extra = <String, dynamic>{};
    final headers = <String, dynamic>{};
    final data = <String, dynamic>{};
    final result = await dio.fetch<Map<String, dynamic>>(
        ApiCallHelper().setStreamType<HttpResponse<ApiResponse<T>>>(Options(
      method: 'GET',
      headers: headers,
      extra: extra,
    )
            .compose(
              dio.options,
              url,
              queryParameters: queryParameters,
              data: data,
            )
            .copyWith(
                baseUrl: ApiCallHelper().combineBaseUrls(
              dio.options.baseUrl,
              baseUrl,
            ))));
    final value = await compute<Map<String, dynamic>, ApiResponse<T>>(
      (message) => ApiResponse<T>.fromJson(
        message,
        (json) => mapper(json as Map<String, dynamic>),
      ),
      result.data!,
    );
    final httpResponse = HttpResponse(value, result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<ApiResponse<T>>> post<T>(
      {required String url,
      Map<String, dynamic>? request,
      required ApiResponseMapper<T> mapper}) async {
    const extra = <String, dynamic>{};
    final headers = <String, dynamic>{};
    final data = <String, dynamic>{};
    final result = await dio.fetch<Map<String, dynamic>>(
        ApiCallHelper().setStreamType<HttpResponse<ApiResponse<T>>>(Options(
      method: 'POST',
      headers: headers,
      extra: extra,
    )
            .compose(
              dio.options,
              url,
              queryParameters: data,
              data: request,
            )
            .copyWith(
                baseUrl: ApiCallHelper().combineBaseUrls(
              dio.options.baseUrl,
              baseUrl,
            ))));
    final value = await compute<Map<String, dynamic>, ApiResponse<T>>(
      (message) => ApiResponse<T>.fromJson(
        message,
        (json) => mapper(json as Map<String, dynamic>),
      ),
      result.data!,
    );
    final httpResponse = HttpResponse(value, result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<ApiResponse<T>>> put<T>(
      {required String url,
      Map<String, dynamic>? request,
      required ApiResponseMapper<T> mapper}) async {
    const extra = <String, dynamic>{};
    final headers = <String, dynamic>{};
    final data = <String, dynamic>{};
    final result = await dio.fetch<Map<String, dynamic>>(
        ApiCallHelper().setStreamType<HttpResponse<ApiResponse<T>>>(Options(
      method: 'PUT',
      headers: headers,
      extra: extra,
    )
            .compose(
              dio.options,
              url,
              queryParameters: data,
              data: request,
            )
            .copyWith(
                baseUrl: ApiCallHelper().combineBaseUrls(
              dio.options.baseUrl,
              baseUrl,
            ))));
    final value = await compute<Map<String, dynamic>, ApiResponse<T>>(
      (message) => ApiResponse<T>.fromJson(
        message,
        (json) => mapper(json as Map<String, dynamic>),
      ),
      result.data!,
    );
    final httpResponse = HttpResponse(value, result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<ApiResponse<T>>> uploadFile<T>(
      {required String url,
      required File file,
      required ApiResponseMapper<T> mapper}) async {
    const extra = <String, dynamic>{};
    final headers = <String, dynamic>{};
    final data = <String, dynamic>{};
    final result = await dio.fetch<Map<String, dynamic>>(
        ApiCallHelper().setStreamType<HttpResponse<ApiResponse<T>>>(Options(
      method: 'POST',
      headers: headers,
      extra: extra,
    )
            .compose(
              dio.options,
              url,
              queryParameters: data,
              data: FormData.fromMap({
                'file': MultipartFile.fromFileSync(file.path),
              }),
            )
            .copyWith(
                baseUrl: ApiCallHelper().combineBaseUrls(
              dio.options.baseUrl,
              baseUrl,
            ))));
    final value = await compute<Map<String, dynamic>, ApiResponse<T>>(
      (message) => ApiResponse<T>.fromJson(
        message,
        (json) => mapper(json as Map<String, dynamic>),
      ),
      result.data!,
    );
    final httpResponse = HttpResponse(value, result);
    return httpResponse;
  }
}
