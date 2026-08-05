import 'package:flutter/material.dart';
import 'dart:io';

class IOSAdapter {
  static bool get isIOS => Platform.isIOS;

  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    if (!isIOS) return EdgeInsets.zero;

    final padding = MediaQuery.of(context).padding;
    return EdgeInsets.only(
      top: padding.top,
      bottom: padding.bottom,
      left: padding.left,
      right: padding.right,
    );
  }

  static double getBottomSafeArea(BuildContext context) {
    if (!isIOS) return 0;
    return MediaQuery.of(context).padding.bottom;
  }
}
