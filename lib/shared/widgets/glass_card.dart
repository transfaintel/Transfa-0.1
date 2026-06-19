import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Soft neumorphic "glass" card used throughout the Transfa UI.
/// Subtle white-to-grey gradient, soft inner highlight, dual drop shadow.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final double? width;
  final double? height;
  final bool elevated;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.radius = 35,
    this.width,
    this.height,
    this.elevated = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        gradient: AppColors.glassGradient,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.white.withValues(alpha: 0.9), width: 1),
        boxShadow: elevated
            ? [
                BoxShadow(
                  color: const Color.fromARGB(255, 233, 233, 233).withValues(alpha: 0.85),
                  blurRadius: 18,
                  offset: const Offset(0, 0),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 0),
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}
