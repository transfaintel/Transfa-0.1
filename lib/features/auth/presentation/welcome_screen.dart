import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/mock_api/mock_data.dart';
import '../../../data/repositories/repositories.dart';

/// "Hello Magic" — minimal white screen with handwritten gradient greeting.
/// Auto-advances; tap or swipe up to skip.
class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..forward();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 2400), _next);
  }

  void _next() {
    _timer?.cancel();
    if (mounted) context.go(Routes.dashboard);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider) ?? MockData.currentUser;
    final firstName = user.fullName.split(' ').first;
    return Scaffold(
      backgroundColor: AppColors.backgroundAlt,
      body: GestureDetector(
        onTap: _next,
        onVerticalDragEnd: (d) {
          if ((d.primaryVelocity ?? 0) < -150) _next();
        },
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: FadeTransition(
                    opacity: _c,
                    child: ScaleTransition(
                      scale: Tween(begin: 0.9, end: 1.0)
                          .animate(CurvedAnimation(parent: _c, curve: Curves.easeOutBack)),
                      child: ShaderMask(
                        shaderCallback: (rect) => AppColors.warmHandwritten.createShader(rect),
                        child: Text(
                          'Hello\n$firstName',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.caveat(
                            fontSize: 76,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            height: 1.05,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                'Swipe up to go home',
                style: AppTypography.body.copyWith(fontSize: 18, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
