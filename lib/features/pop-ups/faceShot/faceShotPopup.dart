
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui' show ImageFilter;

import '../../../../core/constants/assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class FaceShotPopup extends StatefulWidget {
  const FaceShotPopup();

  @override
  State<FaceShotPopup> createState() => FaceShotPopupState();
}

class FaceShotPopupState extends State<FaceShotPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> _exampleFaces = [
    {'asset': Assets.magic, 'gradient': [const Color(0xFF00BCF6), const Color(0xFF006EFF)]},
    {'asset': Assets.Amadioha, 'gradient': [const Color(0xFFB571E3), const Color(0xFF7E2FFF)]},
    {'asset': Assets.avatarJanelle, 'gradient': [const Color(0xFF00BCF6), const Color(0xFF006EFF)]},
    {'asset': Assets.Saphirre, 'gradient': [const Color(0xFFB571E3), const Color(0xFF7E2FFF)]},
  ];

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
    _fadeAnimation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                width: 378,
                decoration: BoxDecoration(
                  color: const Color(0x80FCFCFB),
                  borderRadius: BorderRadius.circular(45),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(45),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0x20FFFFFF),
                        borderRadius: BorderRadius.circular(45),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        Assets.transfaLife,
                                        width: 16,
                                        height: 20,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  const Text(
                                    'Face Shot',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 24,
                                      letterSpacing: 0.02,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _ExampleFaceCard(
                                      assetPath: _exampleFaces[0]['asset'],
                                      gradientColors: _exampleFaces[0]['gradient'],
                                    ),
                                    _ExampleFaceCard(
                                      assetPath: _exampleFaces[1]['asset'],
                                      gradientColors: _exampleFaces[1]['gradient'],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _ExampleFaceCard(
                                      assetPath: _exampleFaces[2]['asset'],
                                      gradientColors: _exampleFaces[2]['gradient'],
                                    ),
                                    _ExampleFaceCard(
                                      assetPath: _exampleFaces[3]['asset'],
                                      gradientColors: _exampleFaces[3]['gradient'],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Your Face Shot is your identity at work, online & everywhere you go. Dress professionally, face forward, and take your finest shot.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                                fontSize: 17,
                                height: 1.5,
                                letterSpacing: 0.02,
                                foreground: Paint()
                                  ..shader = const LinearGradient(
                                    colors: [Color(0xFF363636), Colors.black],
                                  ).createShader(const Rect.fromLTWH(0, 0, 300, 50)),
                              ),
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Container(
                                width: double.infinity,
                                height: 58,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [AppColors.primaryLight, AppColors.primary],
                                  ),
                                  borderRadius: BorderRadius.circular(35),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Take the shot',
                                  style: AppTypography.subheading.copyWith(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class _ExampleFaceCard extends StatelessWidget {
  final String assetPath;
  final List<Color> gradientColors;

  const _ExampleFaceCard({
    required this.assetPath,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 144,
      height: 144,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Image.asset(
          assetPath,
          width: 144,
          height: 144,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
