import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Roboto type scale per DESIGN_NOTES.md.
/// Headings 20/Bold, Body 17/Regular as the canonical sizes; the
/// other steps are derived for hierarchy.
class AppTypography {
  AppTypography._();

  static TextStyle _base(double size, FontWeight weight, Color color) =>
      GoogleFonts.roboto(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: 1.5,
        letterSpacing: size * 0.02,
      );

  static TextStyle displayLarge = _base(
    32,
    FontWeight.w700,
    AppColors.textPrimary,
  );
  static TextStyle displayMedium = _base(
    20,
    FontWeight.w600,
    AppColors.textPrimary,
  );
  static TextStyle headingLarge = _base(
    24,
    FontWeight.w700,
    AppColors.textPrimary,
  );
  static TextStyle heading = _base(20, FontWeight.w700, AppColors.textPrimary);
  static TextStyle subheading = _base(
    18,
    FontWeight.w600,
    AppColors.textPrimary,
  );
  static TextStyle body = _base(17, FontWeight.w400, AppColors.textPrimary);
  static TextStyle bodyStrong = _base(
    17,
    FontWeight.w600,
    AppColors.textPrimary,
  );
  static TextStyle bodyMuted = _base(
    17,
    FontWeight.w400,
    AppColors.textSecondary,
  );
  static TextStyle caption = _base(
    14,
    FontWeight.w400,
    AppColors.textSecondary,
  );
  static TextStyle small = _base(12, FontWeight.w500, AppColors.textMuted);

  static TextStyle button = _base(17, FontWeight.w500, AppColors.textInverse);
}
