import 'package:flutter/material.dart';

/// Design tokens. Brand colors from DESIGN_NOTES.md, neutrals tuned to
/// match the iOS-style neumorphic surfaces in the Figma reference.
class AppColors {
  AppColors._();

  // Brand (per DESIGN_NOTES)
  static const Color primary = Color(0xFFF41E42);
  static const Color primaryLight = Color(0xFFFF4466);

  // Surfaces — slightly desaturated to make the floating glass cards pop.
  static const Color background = Color(0xEEEEEEF1);
  static const Color backgroundAlt = Color(0xFFFCFCFB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF5F5F4);
  static const Color glassTop = Color(0xFFFAFAFA);
  static const Color glassBottom = Color(0xFFE6E6E6);
  static const Color divider = Color(0xFFD9D9D9);

  // Text
  static const Color textPrimary = Color(0xFF000000);
  static const Color textInverse = Color(0xFFFCFCFB);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textMuted = Color(0xFF949494);

  // Status
  static const Color success = Color(0xFF07B826);
  static const Color successLight = Color(0xFF4EE659);
  static const Color warning = Color(0xFFFF9F0A);
  static const Color error = Color(0xFFE53935);

  // Chromatic-aberration secondary (used by the t logo)
  static const Color cyanLeft = Color(0xFF00C2FF);
  static const Color cyanDeep = Color(0xFF006EFF);

  // Soft handwritten welcome gradient (used by "Hello Magic" screen)
  static const LinearGradient warmHandwritten = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [Color(0xFFFFC30F), Color(0xFF9747FF)],
  );

  // Primary CTA gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLight, primary],
  );

  // Brand green — bottom-to-top gradient #07B826 → #4EE659.
  // Used for the chat user bubbles, "New Money" label, the green
  // down-arrow / send fab circles in the support + memo chats.
  static const LinearGradient greenGradient = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [success, successLight],
  );

  static const LinearGradient orangeGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFB347), Color(0xFFFF7A00)],
  );

  // Neumorphic glass card gradient — soft white-to-cool-grey diagonal
  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFEFEFE), Color(0xFFE8E8E8)],
  );

  // Frosted lockscreen wallpaper fallback (used by passcode/home screens
  // when no wallpaper photo is supplied).
  static const LinearGradient wallpaperFallback = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF9C9C9C), Color(0xFF707070), Color(0xFF4D4D4D)],
  );
}
