import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/assets.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/modal_scaffold.dart';

/// Privacy info cards — two distinct concrete screens (ID and Bank).
/// Both are modal cards hovering over the dimmed home wallpaper.
class _PrivacyInfoCard extends StatelessWidget {
  final String title;
  final String body;
  final VoidCallback onTap;
  const _PrivacyInfoCard({required this.title, required this.body, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ModalScaffold(
      child: GestureDetector(
        onTap: onTap,
        child: GlassCard(
          padding: const EdgeInsets.fromLTRB(28, 28, 28, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 64,
                height: 64,
                child: SvgPicture.asset(Assets.privacy, fit: BoxFit.contain),
              ),
              const SizedBox(height: 22),
              Text(title,
                  style: AppTypography.displayMedium
                      .copyWith(fontWeight: FontWeight.w800, fontSize: 28)),
              const SizedBox(height: 18),
              Text(body, style: AppTypography.body.copyWith(fontSize: 18)),
              const SizedBox(height: 18),
              Text('At Transfa, privacy is design.',
                  style: AppTypography.body.copyWith(fontSize: 18)),
              const SizedBox(height: 18),
              Text('Transfa does not sell info.',
                  style: AppTypography.body.copyWith(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}

/// "Transfa & ID Privacy" — first variant in the privacy education flow.
class PrivacyIdScreen extends StatelessWidget {
  const PrivacyIdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _PrivacyInfoCard(
      title: 'Transfa & ID Privacy...',
      body:
          'Identity-related information, National Identity Number (NIN), location, and use patterns may be used to provide assessment to your bank to set up Transfa and prevent identity fraud.',
      onTap: () => context.push(Routes.identityBankPrivacy),
    );
  }
}

/// "Transfa & Bank Privacy" — second variant; advances to location prompt.
class PrivacyBankScreen extends StatelessWidget {
  const PrivacyBankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _PrivacyInfoCard(
      title: 'Transfa & Bank Privacy...',
      body:
          'Bank-related information, Bank Verification Number (BVN), location, and use patterns may be used to provide assessment to your bank to set up Transfa and prevent transaction fraud.',
      onTap: () => context.push(Routes.location),
    );
  }
}
