import 'dart:io';
import 'package:flutter/material.dart';

class DeviceUtils {
  static bool isIOS() => Platform.isIOS;
  static bool isAndroid() => Platform.isAndroid;

  static double getBottomPadding(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return padding.bottom;
  }

  static double getTopPadding(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return padding.top;
  }

  static bool hasNotch(BuildContext context) {
    return MediaQuery.of(context).padding.top > 40;
  }

  static double getKeyboardHeight(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom;
  }
}
