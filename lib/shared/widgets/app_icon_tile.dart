import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// iOS-style rounded square app icon. Renders an SVG/Widget inside the
/// tile and (optionally) a label below.
class AppIconTile extends StatelessWidget {
  final Widget? child;
  final String? svgAsset;
  final String? label;
  final double size;
  final Color? background;
  final Gradient? gradient;
  final VoidCallback? onTap;
  final double iconScale;
  final Color? labelColor;

  const AppIconTile({
    super.key,
    this.child,
    this.svgAsset,
    this.label,
    this.size = 60,
    this.background,
    this.gradient,
    this.onTap,
    this.iconScale = 0.55,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    final radius = size * 0.27;
    final tile = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: SizedBox(
          width: size * iconScale,
          height: size * iconScale,
          child: child ??
              (svgAsset != null
                  ? SvgPicture.asset(svgAsset!, fit: BoxFit.contain)
                  : const SizedBox.shrink()),
        ),
      ),
    );

    final wrapped = onTap != null
        ? InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(radius),
            child: tile,
          )
        : tile;

    if (label == null) return wrapped;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        wrapped,
        const SizedBox(height: 6),
        Text(label!,
            style: AppTypography.caption
                .copyWith(color: labelColor ?? AppColors.textPrimary, fontSize: 13)),
      ],
    );
  }
}
