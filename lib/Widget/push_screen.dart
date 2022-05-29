import 'package:flutter/material.dart';

class Routes {
  static void pushScreen({
    required BuildContext ctx,
    required Widget widget,
  }) {
    Navigator.push(ctx, MaterialPageRoute(builder: (_) {
      return widget;
    }));
  }
}
