import 'package:flutter/material.dart';

class Responsive {
  final BuildContext context;

  Responsive(this.context);

  double get screenWidth => MediaQuery.of(context).size.width;
  double get screenHeight => MediaQuery.of(context).size.height;

  // Breakpoints
  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1200;
  bool get isDesktop => screenWidth >= 1200;

  // Responsive sizing - returns percentage of screen width
  double w(double percentage) => screenWidth * percentage;

  // Responsive sizing - returns percentage of screen height
  double h(double percentage) => screenHeight * percentage;

  // Safe area
  double get statusBarHeight => MediaQuery.of(context).padding.top;
  double get bottomBarHeight => MediaQuery.of(context).padding.bottom;

  // Responsive font size
  double fontSize(double size) {
    double scaleFactor = screenWidth / 375; // 375 is iPhone SE base
    return size * scaleFactor.clamp(0.8, 1.4);
  }

  // Keyboard visibility
  bool get isKeyboardVisible => MediaQuery.of(context).viewInsets.bottom > 0;
}

/// Extension for easier usage
extension ResponsiveExtensions on num {
  double get w => toDouble(); // Used with Responsive.w()
  double get h => toDouble(); // Used with Responsive.h()
}
