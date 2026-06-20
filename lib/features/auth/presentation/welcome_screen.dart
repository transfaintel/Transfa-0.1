import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:transfa/features/dashboard/presentation/dashboard_screen.dart';

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
  bool _isNavigating = false;
  double _dragOffset = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 2400), _next);
  }

  void _next() {
    if (_isNavigating) return;
    _isNavigating = true;
    _timer?.cancel();
    
    if (mounted) {
      // Navigate with slide-up transition
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const DashboardScreen(), // Replace with your actual dashboard widget
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeOutCubic;
            
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      ).then((_) {
        // Reset navigation flag when returning to this screen
        if (mounted) {
          setState(() {
            _isNavigating = false;
            _dragOffset = 0;
          });
        }
      });
    }
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
        onVerticalDragUpdate: (details) {
          setState(() {
            // Only allow upward drag (negative delta)
            if (details.delta.dy < 0) {
              _dragOffset = (_dragOffset + details.delta.dy.abs()).clamp(0, 200);
            }
          });
        },
        onVerticalDragEnd: (details) {
          if ((details.primaryVelocity ?? 0) < -150 || _dragOffset > 100) {
            _next();
          } else {
            // Reset drag offset if not enough to navigate
            setState(() {
              _dragOffset = 0;
            });
          }
        },
        onTap: _next,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          transform: Matrix4.translationValues(0, -_dragOffset, 0),
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
      ),
    );
  }
}

// Make sure to import the Dashboard screen
// import '../../dashboard/presentation/dashboard_screen.dart';