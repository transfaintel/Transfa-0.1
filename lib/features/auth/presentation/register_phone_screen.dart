import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:transfa/shared/widgets/animated_dotted_loader.dart';
import '../../../core/constants/assets.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../features/auth/presentation/unlock_screens.dart';
import '../../pop-ups/checkYourNumber_popup.dart'; // Import the popup

/// "Welcome Home — Unlock with your phone" for **new users** during the
/// landing/onboarding flow. Distinct from [WelcomeHomePhoneScreen] (the
/// returning-user variant) — that one shows "Transfa Passcode" + the
/// New Transfa / Unlock with Face squares; this one shows the red
/// "Continue" pill and a privacy footer with the "See how your info is
/// managed..." link.
class RegisterPhoneScreen extends StatefulWidget {
  const RegisterPhoneScreen({super.key});

  @override
  State<RegisterPhoneScreen> createState() => _RegisterPhoneScreenState();
}

class _RegisterPhoneScreenState extends State<RegisterPhoneScreen> {
  final _phone = TextEditingController(text: '0703 208 4888');
  static const String _validPhoneNumber = '0703 208 4888'; // The expected phone number

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  void _handleContinue() {
    final enteredNumber = _phone.text.trim();
    
    // Check if the entered number matches the expected number
    if (enteredNumber != _validPhoneNumber) {
      // Show the popup if numbers don't match
      _showCheckYourNumberPopup();
    } else {
      // Proceed to verification if numbers match
      context.push(Routes.verifyStartkey);
    }
  }

  void _showCheckYourNumberPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (context) => const CheckYourNumberPopup(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 80, 20, 28),
          child: Column(
            children: [
              _GlassWrapper(
                child: Column(
                  children: [
                    Image.asset(Assets.welcomeHome, width: 72, height: 72),
                    const SizedBox(height: 4),
                    Text(
                      'Welcome Home',
                      style: AppTypography.subheading.copyWith(
                        color: const Color(0xFF8E8E93),
                        fontWeight: FontWeight.w500,
                        fontSize: 21,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Continue with your phone',
                      style: AppTypography.displayMedium.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 26,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              _GlassWrapper(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(height: 35),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: SizedBox(
                            width: 32,
                            height: 26,
                            child: SvgPicture.asset(Assets.Nigerian_Flag, width: 40, height: 30),
                          ),
                        ),
                        const SizedBox(width: 7),
                        Text(
                          'Nigeria',
                          style: AppTypography.subheading.copyWith(fontSize: 17),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _PillField(controller: _phone),
                    const SizedBox(height: 18),
                    _RedLockPill(
                      label: 'Transfa Passcode',
                      onTap: _handleContinue, // Use the validation method
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // 3. Privacy footer — two-people glyph + paragraph + red link.
              // Anchored to the bottom-center of the screen.
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: SizedBox(
                      width: 44,
                      height: 44,
                      child: SvgPicture.asset(Assets.transfaYou, fit: BoxFit.contain),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: AppTypography.body.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 15,
                          height: 1.45,
                        ),
                        children: [
                          const TextSpan(
                            text:
                                'As you continue, your activity and interactions help improve the service. When you pay & receive money, we also use your history to tailor your experience.\n',
                          ),
                          TextSpan(
                            text: 'See how your info is managed…',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => context.push(Routes.privacyPolicy),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassWrapper extends StatelessWidget {
  final Widget child;
  const _GlassWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 236, 236, 236),
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 0.6),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.6),
            blurRadius: 12,
            offset: const Offset(-6, -6),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(8, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _PillField extends StatelessWidget {
  final TextEditingController controller;
  const _PillField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 241, 241, 241),
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
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.phone_rounded,
              color: Colors.white,
              size: 15,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              style: AppTypography.subheading.copyWith(fontSize: 17),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const AnimatedDottedLoader(),
        ],
      ),
    );
  }
}

class _RedLockPill extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _RedLockPill({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF4466), Color(0xFFF41E42)],
          ),
          borderRadius: BorderRadius.circular(40),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_rounded, color: Colors.white, size: 22),
            const SizedBox(width: 10),
            Text(
              label,
              style: AppTypography.subheading.copyWith(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}