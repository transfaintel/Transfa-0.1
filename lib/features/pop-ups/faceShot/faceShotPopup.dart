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
    {
      'asset': Assets.coperateMan,
      'gradient': [const Color(0xFF00BCF6), const Color(0xFF006EFF)],
    },
    {
      'asset': Assets.casualMan,
      'gradient': [const Color(0xFFB571E3), const Color(0xFF7E2FFF)],
    },
    {
      'asset': Assets.avatarJanelle,
      'gradient': [const Color(0xFF00BCF6), const Color(0xFF006EFF)],
    },
    {
      'asset': Assets.Saphirre,
      'gradient': [const Color(0xFFB571E3), const Color(0xFF7E2FFF)],
    },
  ];

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 25,
                        ),
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
                            GridView(
                              padding: const EdgeInsets.all(16),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing:
                                        20, // Equal horizontal spacing
                                    mainAxisSpacing:
                                        20, // Equal vertical spacing
                                    childAspectRatio: 1.0, // Keep it square
                                  ),
                              children: _exampleFaces.map((face) {
                                return _ExampleFaceCard(
                                  assetPath: face['asset'],
                                  gradientColors: face['gradient'],
                                );
                              }).toList(),
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
                                  ..shader =
                                      const LinearGradient(
                                        colors: [
                                          Color(0xFF363636),
                                          Colors.black,
                                        ],
                                      ).createShader(
                                        const Rect.fromLTWH(0, 0, 300, 50),
                                      ),
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
                                    colors: [
                                      AppColors.primaryLight,
                                      AppColors.primary,
                                    ],
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
  final double size; // Add this

  const _ExampleFaceCard({
    required this.assetPath,
    required this.gradientColors,
    this.size = 124, // Default value
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(35)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          size / 2,
        ), // Makes it fully circular
        child: Image.asset(
          assetPath,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
