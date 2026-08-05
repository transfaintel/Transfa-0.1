import 'package:flutter/material.dart';
import '../utils/responsive.dart';

class AppSpacing {
  AppSpacing._();

  // Base spacing values
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  // Responsive spacing
  static double responsiveXs(BuildContext context) =>
      Responsive(context).w(0.01);
  static double responsiveSm(BuildContext context) =>
      Responsive(context).w(0.02);
  static double responsiveMd(BuildContext context) =>
      Responsive(context).w(0.04);
  static double responsiveLg(BuildContext context) =>
      Responsive(context).w(0.06);
  static double responsiveXl(BuildContext context) =>
      Responsive(context).w(0.08);
  static double responsiveXxl(BuildContext context) =>
      Responsive(context).w(0.12);

  static double screenHorizontal(BuildContext context) =>
      Responsive(context).isMobile ? 20 : 40;
}

extension ResponsiveSpacing on num {
  SizedBox get widthBox => SizedBox(width: toDouble());
  SizedBox get heightBox => SizedBox(height: toDouble());
}
