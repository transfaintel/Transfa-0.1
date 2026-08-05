import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import '../utils/responsive.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light(BuildContext context) {
    final base = ThemeData.light(useMaterial3: true);
    final responsive = Responsive(context);

    return base.copyWith(
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryLight,
        secondary: AppColors.primaryLight,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: AppColors.textInverse,
        onSurface: AppColors.textPrimary,
      ),
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.background,
      dividerColor: AppColors.divider,

      // Responsive AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.heading.copyWith(
          fontSize: responsive.fontSize(20),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        toolbarHeight: responsive.isMobile ? 56 : 64,
      ),

      textTheme: TextTheme(
        displayLarge: AppTypography.displayLarge.copyWith(
          fontSize: responsive.fontSize(32),
        ),
        displayMedium: AppTypography.displayMedium.copyWith(
          fontSize: responsive.fontSize(20),
        ),
        headlineLarge: AppTypography.headingLarge.copyWith(
          fontSize: responsive.fontSize(24),
        ),
        headlineMedium: AppTypography.heading.copyWith(
          fontSize: responsive.fontSize(20),
        ),
        titleLarge: AppTypography.subheading.copyWith(
          fontSize: responsive.fontSize(18),
        ),
        bodyLarge: AppTypography.body.copyWith(
          fontSize: responsive.fontSize(17),
        ),
        bodyMedium: AppTypography.body.copyWith(
          fontSize: responsive.fontSize(17),
        ),
        bodySmall: AppTypography.caption.copyWith(
          fontSize: responsive.fontSize(14),
        ),
        labelLarge: AppTypography.button.copyWith(
          fontSize: responsive.fontSize(17),
        ),
        labelSmall: AppTypography.small.copyWith(
          fontSize: responsive.fontSize(12),
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(responsive.isMobile ? 28 : 32),
          ),
        ),
      ),

      splashFactory: InkRipple.splashFactory,

      // Responsive button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, responsive.isMobile ? 50 : 56),
          padding: EdgeInsets.symmetric(
            horizontal: responsive.w(0.05),
            vertical: responsive.isMobile ? 12 : 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.symmetric(
          horizontal: responsive.w(0.04),
          vertical: responsive.isMobile ? 12 : 16,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        constraints: BoxConstraints(minHeight: responsive.isMobile ? 50 : 56),
      ),
    );
  }
}
