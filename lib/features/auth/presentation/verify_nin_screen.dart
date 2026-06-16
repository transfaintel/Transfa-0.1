import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/assets.dart';
import '../../../core/router/routes.dart';
import 'verify_code_screen.dart';

/// "Verify Your NIN" — thin wrapper around [VerifyCodeScreen] with the
/// NIMC tile icon + NIN-specific copy. The keypad in the underlying
/// screen is hidden until the user taps the code-slot area.
class VerifyNinScreen extends StatelessWidget {
  const VerifyNinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return VerifyCodeScreen(
      icon: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(6),
        child: Image.asset(Assets.nimcLogo, fit: BoxFit.contain),
      ),
      title: 'Verify Your NIN',
      subtitle: 'NIMC sent a verification code to\nyour phone: 4888.',
      onVerified: () => context.push(Routes.identityPrivacy),
    );
  }
}
