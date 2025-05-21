import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../clean_architectures/data/model/api_response.dart';

typedef ApiResponseMapper<T> = T Function(Map<String, dynamic> data);

abstract class BaseApi {
  Stream<T> getStream<T>({
    required String url,
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic> data)? onSuccess,
    void Function(CancelToken? cancelToken)? onCancel,
  });

  Stream<Response> postStream({
    required String url,
    Map<String, dynamic>? request,
    void Function(CancelToken? cancelToken)? onCancel,
  });

  Stream<List<T>?> ssePostStream<T>({
    required String url,
    Map<String, dynamic>? request,
    List<T>? Function(List<String>)? onChange,
    T? Function(Map<String, dynamic> data)? onSuccess,
    void Function(CancelToken? cancelToken)? onCancel,
    void Function()? onDone,
  });

  Future<HttpResponse<ApiResponse<T>>> get<T>({
    required String url,
    Map<String, dynamic>? queryParameters,
    required ApiResponseMapper<T> mapper,
  });

  Future<HttpResponse<ApiResponse<T>>> post<T>({
    required String url,
    Map<String, dynamic>? request,
    required ApiResponseMapper<T> mapper,
  });

  Future<HttpResponse<ApiResponse<T>>> put<T>({
    required String url,
    Map<String, dynamic>? request,
    required ApiResponseMapper<T> mapper,
  });

  Future<HttpResponse<ApiResponse<T>>> uploadFile<T>({
    required String url,
    required File file,
    required ApiResponseMapper<T> mapper,
  });
}
