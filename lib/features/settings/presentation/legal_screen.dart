import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';

/// Legal & Regulatory — two glass cards separated by a free-floating
/// bold statement, with a pink back chevron peeking from the bottom-left.
/// Matches the design pasted by the user.
class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 120),
              children: [
                // 1. Intro card — blue globe-with-shield icon.
                GlassCard(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
                  radius: 32,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: SvgPicture.asset(
                          Assets.verifiedWorldwide,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 22),
                      Text(
                        'Legal & Regulatory',
                        style: AppTypography.displayMedium.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 28,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Policies, licenses, and obligations that govern Transfa’s services.',
                        style: AppTypography.body.copyWith(
                          fontSize: 17,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36),

                // 2. Free-floating headline (no card behind it).
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    'Transfa is a mobile financial service incorporated in the state of Delaware, U.S.',
                    style: AppTypography.displayMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      height: 1.35,
                    ),
                  ),
                ),
                const SizedBox(height: 36),

                // 3. Verified Worldwide card — red rosette badge.
                GlassCard(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
                  radius: 32,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: SvgPicture.asset(
                          Assets.verified,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 22),
                      Text(
                        'Verified Worldwide',
                        style: AppTypography.displayMedium.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Transfa enables people and businesses to complete transactions in Naira and U.S. Dollars.',
                        style: AppTypography.body.copyWith(
                          fontSize: 17,
                          color: AppColors.textPrimary,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Our banking partners and service providers are regulated by FinCen, CBN, and EuroCen.',
                        style: AppTypography.body.copyWith(
                          fontSize: 17,
                          color: AppColors.textPrimary,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Floating pink back chevron — peeks from the bottom-left.
            Positioned(
              left: 20,
              bottom: 16,
              child: _BackFab(onTap: () => context.pop()),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackFab extends StatelessWidget {
  final VoidCallback onTap;
  const _BackFab({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.chevron_left_rounded,
          color: Color(0xFFFF375F),
          size: 28,
        ),
      ),
    );
  }
}
