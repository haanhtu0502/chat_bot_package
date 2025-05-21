import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';

import 'connectivity_service.dart';

mixin ConnectivityMixin<T extends StatefulWidget> on State<T> {
  final _connectivityService = ConnectivityService();

  ConnectivityResultCallback? _callBack;

  final ValueNotifier<bool> isOnline = ValueNotifier(false);

  void initCallBack({bool checkMounted = true}) {
    isOnline.value = _connectivityService.isOnline;
    _callBack = (ConnectivityResult result) {
      if (!mounted && checkMounted) return;
      if (result == ConnectivityResult.none) {
        isOnline.value = false;
        handleOffline();
      } else if (result == ConnectivityResult.wifi) {
        isOnline.value = true;
        handleOnline();
      }
    };
    _connectivityService.listen(_callBack!);
  }

  void removeCallBack() {
    if (_callBack != null) {
      _connectivityService.off(_callBack!);
    }
  }

  void disposeConnectivity() {
    _connectivityService.dispose();
  }

  void handleOffline();

  void handleOnline();
}
