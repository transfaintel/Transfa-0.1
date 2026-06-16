import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/assets.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/modal_scaffold.dart';
import 'rainbow_face_ring.dart';

/// CashDrop scan/pay surface — rainbow ring with empty centre while
/// scanning, plus instructional copy and a blue CashDrop CTA.
class CashDropScanScreen extends StatelessWidget {
  const CashDropScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModalScaffold(
      sheetHandle: true,
      child: Column(
        children: [
          const SizedBox(height: 16),
          const RainbowFaceRing(size: 320),
              const SizedBox(height: 8),
              Text('CashDrop',
                  style: AppTypography.displayMedium.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.black.withValues(alpha: 0.08))),
              const Spacer(),
              Text(
                'To pay, try holding this Transfa\nover another Transfa.',
                textAlign: TextAlign.center,
                style: AppTypography.subheading.copyWith(
                    fontSize: 19, color: Colors.black.withValues(alpha: 0.18)),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _FAB.warm(
                    icon: Icons.home_rounded,
                    onTap: () => context.go(Routes.dashboard),
                  ),
                  Opacity(
                    opacity: 0.35,
                    child: _FAB.muted(
                      icon: Icons.south_rounded,
                      onTap: () {},
                    ),
                  ),
                  _FAB.gradient(
                    onTap: () {},
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00C2FF), Color(0xFF006EFF)],
                    ),
                    icon: null,
                    body: SizedBox(
                      width: 32,
                      height: 32,
                      child: SvgPicture.asset(Assets.cashDrop),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
  }
}

class _FAB extends StatelessWidget {
  final IconData? icon;
  final Widget? child;
  final VoidCallback onTap;
  final Color? color;
  final Gradient? gradient;

  const _FAB({
    this.icon,
    this.child,
    required this.onTap,
    this.color,
    this.gradient,
  });

  factory _FAB.warm({required IconData icon, required VoidCallback onTap}) => _FAB(
        icon: icon,
        onTap: onTap,
        gradient: const LinearGradient(
          colors: [Color(0xFFFFB347), Color(0xFFCB6BBA)],
        ),
      );

  factory _FAB.gradient({
    IconData? icon,
    Widget? body,
    required VoidCallback onTap,
    required Gradient gradient,
  }) =>
      _FAB(icon: icon, onTap: onTap, gradient: gradient, child: body);

  factory _FAB.muted({required IconData icon, required VoidCallback onTap}) =>
      _FAB(icon: icon, onTap: onTap, color: const Color(0x22000000));

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          gradient: gradient,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: child ?? Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}
