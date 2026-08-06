import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/assets.dart';
import '../../core/theme/app_typography.dart';
import './homeFab.dart';
import 'transfa_logo.dart';

/// Repeating header used on the send/recipient/receipt modal cards:
/// dark "t" app icon tile + "Transfa" text + X close button on the right.
class TransfaModalHeader extends StatelessWidget {
  final VoidCallback? onClose;
  final String title;

  const TransfaModalHeader({super.key, this.onClose, this.title = 'Transfa'});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const TransfaMark(size: 28, white: true),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: AppTypography.displayMedium.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 28,
            ),
          ),
        ),
        GestureDetector(
          onTap: onClose ?? () => Navigator.maybePop(context),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.close_rounded,
              size: 22,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

/// Bottom segmented "Today / Keypad" tab control used on Transfa AI + Amount.
class TodayKeypadTabs extends StatelessWidget {
  final bool keypadActive;
  final VoidCallback? onTodayTap;
  final VoidCallback? onKeypadTap;
  const TodayKeypadTabs({
    super.key,
    required this.keypadActive,
    this.onTodayTap,
    this.onKeypadTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _Tab(
              label: 'Today',
              svgAsset: Assets.today,
              active: !keypadActive,
              activeColor: const Color(0xFFFF375F),
              onTap: onTodayTap,
            ),
          ),
          Expanded(
            child: _Tab(
              label: 'Keypad',
              svgAsset: Assets.keypad,
              active: keypadActive,
              activeColor: const Color(0xFFFF375F),
              onTap: onKeypadTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final String svgAsset;
  final bool active;
  final Color activeColor;
  final VoidCallback? onTap;
  const _Tab({
    required this.label,
    required this.svgAsset,
    required this.active,
    required this.activeColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? activeColor : Colors.black87;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            // When active, a second "glass" pill sits on top of the
            // parent container — softer white + subtle elevation so it
            // reads as a toggle thumb. When inactive, the row is
            // transparent and lets the parent glass show through.
            color: active ? Colors.transparent : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: active
                  ? Colors.white.withValues(alpha: 0.7)
                  : Colors.transparent,
              width: 1,
            ),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.10),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.9),
                      blurRadius: 6,
                      offset: const Offset(0, -1),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: SvgPicture.asset(
                  svgAsset,
                  fit: BoxFit.contain,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: AppTypography.caption.copyWith(
                  color: color,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
