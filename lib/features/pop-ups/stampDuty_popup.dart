import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/assets.dart';

// ============================================================
// STAMP DUTY POPUP (slides from top)
// ============================================================
class StampDutyPopup extends StatefulWidget {
  const StampDutyPopup();

  @override
  State<StampDutyPopup> createState() => _StampDutyPopupState();
}

class _StampDutyPopupState extends State<StampDutyPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(
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
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Center(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: 270,
                height: 360,
                decoration: BoxDecoration(
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
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0x80FCFCFB), // 50% white
                          borderRadius: BorderRadius.circular(45),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Header Card
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // CBN Logo Container
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            const Color(0xFFFCFCFB),
                                            const Color(
                                              0xFFFCFCFB,
                                            ).withValues(alpha: 0.7),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      alignment: Alignment.center,
                                      child: const _CbnLogo(),
                                    ),
                                    const SizedBox(height: 18),
                                    // Stamp Duty Title
                                    const Text(
                                      'Stamp Duty',
                                      style: TextStyle(
                                        fontFamily: 'Arial Rounded MT Bold',
                                        fontSize: 20,
                                        height: 1.5,
                                        letterSpacing: 0.02,
                                        color: Color(0xFF000000),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    // Description Text
                                    const Text(
                                      'From January 1, 2026, payments above ₦10,000 incur a ₦50 "Stamp Duty" under Nigeria\'s Tax Law.',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 17,
                                        height: 1.5,
                                        letterSpacing: 0.02,
                                        color: Color(0xFF000000),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              // Options Container
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Column(
                                  children: [
                                    // OK Button
                                    _StampDutyButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                    ),
                                  ],
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
      ),
    );
  }
}

class _StampDutyButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _StampDutyButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFF4466), Color(0xFFF41E42)],
          ),
          borderRadius: BorderRadius.circular(35),
        ),
        alignment: Alignment.center,
        child: const Text(
          'OK',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            fontSize: 17,
            height: 1.5,
            letterSpacing: 0.02,
            color: Color(0xFFFCFCFB),
          ),
        ),
      ),
    );
  }
}

class _CbnLogo extends StatelessWidget {
  const _CbnLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 40,
      
      child: Center(
        child: Image.asset(Assets.cbnLogo),
      ),
    );
  }
}
