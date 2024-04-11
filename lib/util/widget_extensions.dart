import 'package:flutter/widgets.dart';

extension WidgetExts on Widget {
  void doWhenRendered(void Function(Duration) callback) {
    WidgetsBinding.instance.addPostFrameCallback(callback);
  }
}
