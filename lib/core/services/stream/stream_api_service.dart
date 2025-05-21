import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

import '../../components/configurations/configurations.dart';
import '../../components/network/api/base_api.dart';
import '../../components/network/api/dio_api.dart';
import '../../dependency_injection/di.dart';
import 'stream_mixin.dart';

const _kEventTag = "event";
const _kDataTag = "data";

class ConfigDio {
  final String? baseUrl;
  final Map<String, dynamic>? headers;

  ConfigDio({this.baseUrl, this.headers});
}

class StreamApiService<T> {
  final String url;
  final String eventGet;
  final Map<String, dynamic>? queryParameters;
  final ConfigDio? configDio;
  final T Function(Map<String, dynamic>) mappingData;

  final Function(T)? onListenDataChange;
  final Function()? onDone;

  late final BaseApi _api;
  late final String _baseUrl;

  StreamSubscription<List<T>?>? _subscription;

  /// Constructor to initialize the stream API service.
  /// Configures Dio client and sets up dependencies.
  StreamApiService({
    this.onListenDataChange,
    this.onDone,
    required this.url,
    required this.eventGet,
    required this.mappingData,
    this.queryParameters,
    this.configDio,
  }) {
    var dio = injector.isRegistered<Dio>() ? injector.get<Dio>() : Dio();

    if (configDio != null) {
      dio = Dio(BaseOptions(
        baseUrl: configDio!.baseUrl ?? '',
        contentType: Headers.jsonContentType,
        headers: configDio!.headers,
      ));
    }

    _baseUrl = configDio?.baseUrl ?? Configurations.baseUrl;
    _api = DioApi(dio);
  }

  /// Parses and maps incoming event stream data.
  /// Filters by the `eventGet` and applies `mappingData` to JSON payloads.
  List<T> _dataListHandler(List<String> data) {
    final result = <T>[];
    var addResult = false;

    for (var element in data) {
      if (element.contains(_kEventTag)) {
        final eventLine = element.replaceFirst("event: ", "").trim();
        addResult = eventLine.contains(eventGet);
      }

      if (element.contains(_kDataTag) && addResult) {
        final dataLine = element.replaceFirst("data: ", "").trim();
        final decoded = json.decode(dataLine);

        if (decoded is Map<String, dynamic>) {
          result.add(mappingData(decoded));
        }
      }
    }

    return result;
  }

  /// Starts the SSE stream using a POST request.
  /// Listens for data and passes valid stream items to the mixin handler.
  void onPostStream({Map<String, dynamic>? queryParameters}) {
    if (_subscription != null) return;

    _subscription = _api
        .ssePostStream<T>(
      url: _baseUrl + url,
      request: queryParameters ?? this.queryParameters,
      onCancel: (_) {},
      onChange: _dataListHandler,
      onSuccess: (_) => null,
      onDone: () => _cancelStream(null),
    )
        .listen(
      (streamResponse) {
        if (streamResponse?.isNotEmpty ?? false) {
          for (var element in streamResponse!) {
            onListenDataChange?.call(element);
          }
        }
      },
    );
  }

  /// Cancels the current SSE stream subscription.
  /// Notifies the mixin that the stream is done.
  void _cancelStream(dynamic error) {
    _subscription?.cancel();
    _subscription = null;
    onDone?.call();
  }
}
