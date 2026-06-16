import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'glass_card.dart';
import 'modal_scaffold.dart';
import 'pill_button.dart';

/// Reusable info / alert modal card used across the app for:
/// Bank Unavailable, No Internet, Insufficient Money, Stamp Duty,
/// Face Not Recognized, Get Power, etc.
///
/// Shape: glass card with a single coloured rounded-square icon tile,
/// large title, body text, optional row block (e.g. bank chip), then a
/// stack of one or more pill buttons at the bottom.
class InfoModalCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final String body;
  final List<Widget> rows;
  final List<Widget> actions;
  const InfoModalCard({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.rows = const [],
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return ModalScaffold(
      child: GlassCard(
        padding: const EdgeInsets.fromLTRB(24, 26, 24, 26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 60, height: 60, child: icon),
            const SizedBox(height: 20),
            Text(title,
                style: AppTypography.displayMedium
                    .copyWith(fontWeight: FontWeight.w800, fontSize: 26)),
            const SizedBox(height: 10),
            Text(body, style: AppTypography.body.copyWith(fontSize: 18)),
            if (rows.isNotEmpty) ...[
              const SizedBox(height: 22),
              for (final r in rows) ...[r, const SizedBox(height: 10)],
            ],
            if (actions.isNotEmpty) ...[
              const SizedBox(height: 18),
              for (var i = 0; i < actions.length; i++) ...[
                actions[i],
                if (i < actions.length - 1) const SizedBox(height: 10),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

/// Standard coloured rounded-square app-icon tile.
class AppIconTile extends StatelessWidget {
  final Widget child;
  final Color? color;
  final Gradient? gradient;
  final double size;
  final double radius;
  const AppIconTile({
    super.key,
    required this.child,
    this.color,
    this.gradient,
    this.size = 60,
    this.radius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
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
      alignment: Alignment.center,
      child: child,
    );
  }
}

/// Selectable row used inside info modals — e.g. "Transfa ✓" chip.
class CheckRow extends StatelessWidget {
  final Widget leading;
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  const CheckRow({
    super.key,
    required this.leading,
    required this.label,
    this.selected = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(width: 40, height: 40, child: Center(child: leading)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label,
                  style: AppTypography.subheading.copyWith(fontSize: 20)),
            ),
            if (selected)
              const Icon(Icons.check_rounded, color: AppColors.primary, size: 26),
          ],
        ),
      ),
    );
  }
}

/// Row variant with a trailing red action pill (e.g. "Transfa  [Add]").
class ActionPillRow extends StatelessWidget {
  final Widget leading;
  final String label;
  final String actionLabel;
  final VoidCallback? onAction;
  const ActionPillRow({
    super.key,
    required this.leading,
    required this.label,
    required this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.fromLTRB(14, 8, 8, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(width: 40, height: 40, child: Center(child: leading)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style: AppTypography.subheading.copyWith(fontSize: 20)),
          ),
          PillButton(
            label: actionLabel,
            onPressed: onAction,
            width: 90,
            height: 44,
          ),
        ],
      ),
    );
  }
}
