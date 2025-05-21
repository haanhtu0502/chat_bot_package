import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

typedef ConnectivityResultCallback = void Function(ConnectivityResult result);

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();

  factory ConnectivityService() => _instance;

  ConnectivityService._internal() {
    _initConnectivity();
  }

  /// [Connectivity] instance
  final Connectivity _connectivity = Connectivity();

  /// [ConnectivityResult] current result
  ConnectivityResult _currentResult = ConnectivityResult.none;

  /// [ConnectivityResult] callbacks
  final List<ConnectivityResultCallback> _callbacks = [];

  /// [StreamSubscription] for connectivity changes
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  /// [ConnectivityResult] current result
  void _initConnectivity() {
    if (_subscription != null) {
      return;
    }
    _subscription = _connectivity.onConnectivityChanged.listen((event) {
      final newResult = event.firstOrNull ?? ConnectivityResult.none;

      if (_currentResult != newResult) {
        _currentResult = newResult;
        _emit();
      }
    });
  }

  /// Check the current connectivity status
  Future<ConnectivityResult> checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    _currentResult = result.isNotEmpty ? result.first : ConnectivityResult.none;
    return _currentResult;
  }

  /// Listen to connectivity changes
  void listen(ConnectivityResultCallback callback) {
    if (!_callbacks.contains(callback)) {
      _callbacks.add(callback);
    }

    // Immediately notify with the current state
    callback(_currentResult);

    if (_subscription == null) {
      _initConnectivity();
    }
  }

  /// Stop listening to connectivity changes
  void off(ConnectivityResultCallback? callback) {
    if (callback != null) {
      _callbacks.remove(callback);
    }
    if (_callbacks.isEmpty) {
      _subscription?.cancel();
      _subscription = null;
    }
  }

  /// Dispose of the service
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _callbacks.clear();
  }

  void _emit() {
    for (var callback in List<ConnectivityResultCallback>.from(_callbacks)) {
      try {
        callback(_currentResult);
      } catch (e) {
        // Log or handle individual callback errors if needed
      }
    }
  }

  bool get isOnline => _currentResult == ConnectivityResult.wifi;
}
