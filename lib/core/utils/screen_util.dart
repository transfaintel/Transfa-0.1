import 'package:flutter/material.dart';

class ScreenUtil {
  final BuildContext context;

  ScreenUtil(this.context);

  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;

  // Device-specific adjustments
  bool get isIPhoneSE => width <= 375 && height <= 667;
  bool get isIPhone8 => width == 375 && height == 667;
  bool get isIPhoneX => width == 375 && height == 812;
  bool get isIPhone12 => width == 390 && height == 844;
  bool get isIPhone14ProMax => width == 430 && height == 932;
  bool get isAndroid => Theme.of(context).platform == TargetPlatform.android;
  bool get isIOS => Theme.of(context).platform == TargetPlatform.iOS;

  // Safe area insets
  EdgeInsets get safeArea => MediaQuery.of(context).padding;

  // Keyboard visibility
  bool get isKeyboardVisible => MediaQuery.of(context).viewInsets.bottom > 0;
}
