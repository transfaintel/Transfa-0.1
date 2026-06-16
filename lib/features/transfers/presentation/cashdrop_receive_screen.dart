import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/assets.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/mock_api/mock_data.dart';
import '../../../data/repositories/repositories.dart';
import '../../../shared/widgets/modal_scaffold.dart';
import 'rainbow_face_ring.dart';

/// Modal-style CashDrop receive screen — rainbow ring frames the user's
/// face; bottom toolbar exposes home, scan, and mic shortcuts.
class CashDropReceiveScreen extends ConsumerWidget {
  const CashDropReceiveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider) ?? MockData.currentUser;
    return ModalScaffold(
      sheetHandle: true,
      child: Column(
        children: [
          const SizedBox(height: 12),
          RainbowFaceRing(
                size: 320,
                child: Image.asset(Assets.magic, fit: BoxFit.cover),
              ),
              const SizedBox(height: 8),
              Text(user.fullName.split(' ').first,
                  style: AppTypography.displayMedium.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.black.withValues(alpha: 0.08))),
              const Spacer(),
              Text(
                'To receive, scan your face with\nanother Transfa.',
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
                    onTap: () => context.go('/dashboard'),
                  ),
                  _FAB.gradient(
                    icon: Icons.south_rounded,
                    onTap: () {},
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00C2FF), Color(0xFF006EFF)],
                    ),
                  ),
                  _FAB.muted(
                    icon: Icons.mic_rounded,
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        );
  }
}

class _FAB extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  final Gradient? gradient;
  final double opacity;

  const _FAB({
    required this.icon,
    required this.onTap,
    this.color,
    this.gradient,
    this.opacity = 1,
  });

  factory _FAB.warm({required IconData icon, required VoidCallback onTap}) => _FAB(
        icon: icon,
        onTap: onTap,
        gradient: const LinearGradient(
          colors: [Color(0xFFFFB347), Color(0xFFCB6BBA)],
        ),
      );

  factory _FAB.gradient({
    required IconData icon,
    required VoidCallback onTap,
    required Gradient gradient,
  }) =>
      _FAB(icon: icon, onTap: onTap, gradient: gradient);

  factory _FAB.muted({required IconData icon, required VoidCallback onTap}) =>
      _FAB(icon: icon, onTap: onTap, color: const Color(0x22000000), opacity: 0.35);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: GestureDetector(
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
          child: Icon(icon, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}
