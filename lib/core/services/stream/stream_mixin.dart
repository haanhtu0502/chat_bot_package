import 'package:flutter/material.dart';

mixin StreamMixin<T extends StatefulWidget> on State<T> {
  void onListenDataChange(dynamic data);

  void onDone();
}
