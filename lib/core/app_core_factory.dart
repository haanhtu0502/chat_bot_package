import 'dart:io';

import 'package:chat_bot_package/core/components/configurations/open_ai_api_config.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

class AppCoreFactory {
  static Dio createDio(String baseUrl) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {
          "content-type": "application/json",
          "Accept": "*/*",
          "OpenAI-Beta": "assistants=v2"
        },
      ),
    )
      ..interceptors.add(TokenInterceptor())
      ..interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    if (!kIsWeb) {
      // ignore: deprecated_member_use
      (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }
    return dio;
  }
}

class TokenInterceptor implements Interceptor {
  @override
  // ignore: deprecated_member_use
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    return handler.next(err);
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String apiKey = ChatBotConfig().getApiKey;

    options.headers["Authorization"] = "Bearer $apiKey";
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }
}
