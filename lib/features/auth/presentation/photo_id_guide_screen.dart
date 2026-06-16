import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';

/// Photo ID Guide — three stacked glass cards: intro + Passport sample
/// + National ID sample. A close button is pinned to the bottom-right.
class PhotoIdGuideScreen extends StatelessWidget {
  const PhotoIdGuideScreen({super.key});

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
                // 1. Intro card — red rounded-square Photo Guide icon.
                GlassCard(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
                  radius: 32,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        Assets.photoIdGuide,
                        width: 60,
                        height: 60,
                      ),
                      const SizedBox(height: 22),
                      Text(
                        'Photo ID Guide',
                        style: AppTypography.displayMedium.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 28,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Examples of how to verify your\nPassport, National ID & License.',
                        style: AppTypography.body.copyWith(
                          fontSize: 17,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),

                // 2. Passport sample card.
                _DocCard(
                  title: 'Passport',
                  subtitle: 'Show your Passport Data Page.',
                  sample: const _PassportSample(),
                ),
                const SizedBox(height: 22),

                // 3. National ID sample card.
                _DocCard(
                  title: 'National ID',
                  subtitle: 'Show your National ID front view.',
                  sample: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(
                      Assets.ninSlip,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 260,
                    ),
                  ),
                ),
              ],
            ),

            // Floating close (X) button — bottom right.
            Positioned(
              right: 20,
              bottom: 16,
              child: _CloseFab(onTap: () => context.pop()),
            ),
          ],
        ),
      ),
    );
  }
}

class _DocCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget sample;
  const _DocCard({
    required this.title,
    required this.subtitle,
    required this.sample,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      radius: 32,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.displayMedium.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTypography.body.copyWith(
              fontSize: 17,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 18),
          sample,
        ],
      ),
    );
  }
}

/// Passport data-page sample. Renders `assets/images/passport_sample.jpg`
/// when present; otherwise falls back to a styled MRZ-style placeholder
/// that mirrors the layout so the screen reads correctly even before the
/// real photo is dropped in.
class _PassportSample extends StatelessWidget {
  const _PassportSample();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Image.asset(
        Assets.passportSample,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (_, _, _) => const _PassportPlaceholder(),
      ),
    );
  }
}

class _PassportPlaceholder extends StatelessWidget {
  const _PassportPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFCFE6E0), Color(0xFFB8D8CF), Color(0xFFE0EDE6)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'FEDERAL REPUBLIC OF NIGERIA',
                style: AppTypography.small.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F4C3A),
                ),
              ),
              Text(
                'Passport / Passeport',
                style: AppTypography.small.copyWith(
                  fontSize: 10,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 90,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Field('SURNAME / NOM', 'UGURU'),
                      _Field('GIVEN NAMES / PRÉNOMS', 'PHILIP'),
                      _Field('NATIONALITY', 'NIGERIAN'),
                      _Field('DATE OF BIRTH', '10 DEC / DÉC 93'),
                      _Field('NIN', '62116591331'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 26,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'P<NGAUGURU<<PHILIP<<<<<<<<<<<<<<<<<<<<<<<',
              style: AppTypography.small.copyWith(
                fontSize: 9,
                fontFamily: 'monospace',
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 26,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'B001890708NGA9312100M250615962116591331<<<26',
              style: AppTypography.small.copyWith(
                fontSize: 9,
                fontFamily: 'monospace',
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final String value;
  const _Field(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.small.copyWith(
              fontSize: 8,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: AppTypography.bodyStrong.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CloseFab extends StatelessWidget {
  final VoidCallback onTap;
  const _CloseFab({required this.onTap});

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
          Icons.close_rounded,
          color: Colors.black,
          size: 28,
        ),
      ),
    );
  }
}
