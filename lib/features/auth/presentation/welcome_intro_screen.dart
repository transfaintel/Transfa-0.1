import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:transfa/features/auth/presentation/onboarding_screen.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/transfa_logo.dart';

/// Soft welcome screen with the chromatic logo and a "Welcome to **Transfa**"
/// title. Swiping up advances to the feature onboarding.
class WelcomeIntroScreen extends StatefulWidget {
  const WelcomeIntroScreen({super.key});

  @override
  State<WelcomeIntroScreen> createState() => _WelcomeIntroScreenState();
}

class _WelcomeIntroScreenState extends State<WelcomeIntroScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 700))..forward();
  
  double _dragOffset = 0;
  bool _isNavigating = false;

  void _next() {
    if (_isNavigating) return;
    _isNavigating = true;
    
    // Navigate with slide-up transition
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const OnboardingScreen(),
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

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FadeTransition(
                          opacity: _c,
                          child: const TransfaLogo(size: 110),
                        ),
                        const SizedBox(height: 28),
                        FadeTransition(
                          opacity: _c,
                          child: SlideTransition(
                            position: Tween(begin: const Offset(0, 0.2), end: Offset.zero).animate(
                              CurvedAnimation(parent: _c, curve: Curves.easeOut),
                            ),
                            child: Column(
                              children: [
                                Text('Welcome to',
                                    style: AppTypography.displayLarge.copyWith(fontSize: 40)),
                                const SizedBox(height: 6),
                                Text(
                                  'Transfa',
                                  style: AppTypography.displayLarge.copyWith(
                                    fontSize: 60,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                FadeTransition(
                  opacity: _c,
                  child: Text(
                    'Swipe up to get started',
                    style: AppTypography.body.copyWith(
                      fontSize: 18,
                      color: AppColors.textPrimary,
                    ),
                  ),
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