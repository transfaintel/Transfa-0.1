import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/transfa_logo.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  static const _linkedItems = [
    _PrivacyItem(Icons.person_outline_rounded, 'Contact Info'),
    _PrivacyItem(Icons.inventory_2_outlined, 'History'),
    _PrivacyItem(Icons.navigation_outlined, 'Location'),
    _PrivacyItem(Icons.badge_outlined, 'Identifiers'),
    _PrivacyItem(Icons.more_horiz_rounded, 'Other Info'),
  ];

  static const _notLinkedItems = [
    _PrivacyItem(Icons.bar_chart_rounded, 'Usage Data'),
    _PrivacyItem(Icons.medical_services_outlined, 'Diagnostics'),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFEEEEF1),
    body: SafeArea(
      child: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(20, 72, 20, 120),
            children: [
              _buildIntroCard(),
              const SizedBox(height: 40),
              _buildPageNote(context),
              const SizedBox(height: 40),
              _buildLinkedCard(
                context,
                Assets.privacySymbol6,
                'Info Linked to You',
                'The following info may be collected\nand linked to your identity:',
                _linkedItems,
              ),
              const SizedBox(height: 40),
              _buildLinkedCard(
                context,
                Assets.contactClosed,
                'Info Not Linked to You',
                'The following info may be collected but it is not linked to your identity:',
                _notLinkedItems,
              ),
              const SizedBox(height: 40),
              _buildInfoSection(
                Assets.privateInfoBlue,
                'How we manage info...',
                'Transfa may use your info to: Process and facilitate your payments securely and privately. Verify your identity to prevent identity and financial fraud. Provide you with customer support. Personalize Transfa\'s services and enhance your experience. Detect and prevent unauthorized activity in order to keep your account private and secure. Comply with legal obligations, applicable laws, regulations, and industry standards.',
              ),
              const SizedBox(height: 40),
              _buildInfoSection(
                Assets.infoWeSee,
                'Info we see...',
                'Information you provide: Account Information: when you sign up for Transfa, we see & collect your name, phone number, banking information, and identifiers to create and manage your Transfa. Transaction Details: when you send or receive money, we see & collect details like the amount, date, time, and recipient information to process and record your transactions. Verification Information: to comply with legal requirements and ensure your privacy & security, we see and collect your government-issued ID and other identity information during account setup, or for certain transactions.',
              ),
              const SizedBox(height: 40),
              _buildInfoSection(
                Assets.autoCollect,
                'Info we may collect automatically...',
                'Device Information: to personalize your payment experience, we may collect details about your device, such as the model, operating system, IP address, cellular & internet service provider, and unique device identifiers to optimize performance and enhance security. Usage Data: your app interactions, transaction patterns, and connected accounts may be used to provide assessment to Transfa to set up your account and prevent identity and transaction fraud. Location Data: when you enable location services, we may use your location to provide location-based experiences like community service, cashback, rewards.',
              ),
              const SizedBox(height: 40),
              _buildInfoSection(
                Assets.thirdParty,
                'Info from third parties...',
                'Financial Institutions: to ensure compliance with financial regulations, we may request and or receive information from banks or payment processors to verify certain transactions, senders, or receivers. Analytics Partners: to understand how our service is used and to improve the service for you, we may work with trusted analytics partners to aggregate anonymized and generalized info from time to time.',
                iconColor: Colors.white,
              ),
              const SizedBox(height: 40),
              _buildInfoSection(
                Assets.sharingInfo,
                'Sharing information...',
                'We only share information when necessary, such as: With identity services to verify your identity and government-issued ID. With financial institutions to verify your financial status, understand your financial connections, and to process your transactions. With authorized government agencies to comply with legal and regulatory requirements. With other trusted service providers who assist us in operating Transfa, under strict confidentiality. We do not share your info for marketing purposes or with third parties unrelated to Transfa\'s services.',
              ),
              const SizedBox(height: 40),
              _buildInfoSection(
                Assets.howWeKeepInfo,
                'How we keep info...',
                'We keep your info for only as long as necessary to personalize your Transfa, provide our services, comply with legal & regulatory obligations, or resolve disputes.\n\nWhen no longer needed or necessary to be linked to you, we securely anonymize your info.',
                boldLines: [
                  'When no longer needed or necessary to be linked to you, we securely anonymize your info.',
                ],
              ),
              const SizedBox(height: 40),
              _buildInfoSection(
                Assets.security,
                'How we secure info...',
                'Access to your information is limited to authorized Transfa personnel who need it to perform their roles.\n\nTransactions are end-to-end encrypted from your Transfa to the cloud.\n\nYour info is always private and secure.',
                boldLines: ['Your info is always private and secure.'],
              ),
              const SizedBox(height: 40),
              _buildInfoSection(
                Assets.security,
                'Rights Granted by You - Payment Content.',
                'By paying and receiving money from anyone\n\nBy connecting your BVN and NIN, for Nigeria, and any equivalent identity service for other countries\n\nYour info is always private and secure.',
                boldLines: ['Your info is always private and secure.'],
              ),
              const SizedBox(height: 40),
              _buildTransfaAndYouCard(),
              const SizedBox(height: 40),
            ],
          ),
          Positioned(
            left: 20,
            bottom: 16,
            child: _BackFab(onTap: () => context.pop()),
          ),
        ],
      ),
    ),
  );

  Widget _buildIntroCard() => GlassCard(
    padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
    radius: 32,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(Assets.privacy, width: 60, height: 60),
        const SizedBox(height: 22),
        Text(
          'Privacy Policy',
          style: AppTypography.displayMedium.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 28,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Learn how Transfa keeps your\nmoney & identity private.',
          style: AppTypography.body.copyWith(
            fontSize: 17,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    ),
  );

  Widget _buildPageNote(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 6),
    child: Text(
      'Transfa’s privacy practices may include handling of info as described below.',
      style: AppTypography.displayMedium.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 20,
        height: 1.35,
      ),
    ),
  );

  Widget _buildLinkedCard(
    BuildContext context,
    String asset,
    String title,
    String subtitle,
    List<_PrivacyItem> items,
  ) => GlassCard(
    padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
    radius: 32,
    child: Column(
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: SvgPicture.asset(asset, fit: BoxFit.cover),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: AppTypography.displayMedium.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: AppTypography.body.copyWith(
            fontSize: 16,
            color: AppColors.textMuted,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 22),
        LayoutBuilder(
          builder: (context, c) {
            final w = (c.maxWidth - 16) / 2;
            return Wrap(
              spacing: 16,
              runSpacing: 12,
              children: items
                  .map((i) => SizedBox(width: w, child: _PrivacyRow(i)))
                  .toList(),
            );
          },
        ),
      ],
    ),
  );

  Widget _buildInfoSection(
    String asset,
    String title,
    String text, {
    Color? iconColor,
    List<String> boldLines = const [],
  }) => GlassCard(
    radius: 32,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: SvgPicture.asset(
            asset,
            width: 60,
            height: 60,
            colorFilter: iconColor != null
                ? ColorFilter.mode(iconColor, BlendMode.srcIn)
                : null,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 22),
        Text(
          title,
          style: AppTypography.displayMedium.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 16),
        ...text
            .split('\n\n')
            .map(
              (p) => Column(
                children: [
                  Text(
                    p,
                    style: AppTypography.body.copyWith(
                      fontSize: 17,
                      color: AppColors.textPrimary,
                      height: 1.5,
                      fontWeight: boldLines.contains(p)
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                  if (p != text.split('\n\n').last) const SizedBox(height: 16),
                ],
              ),
            ),
      ],
    ),
  );

  Widget _buildTransfaAndYouCard() => GlassCard(
    padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
    radius: 32,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 60,
          height: 60,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16),
          ),
          child: TransfaMark(size: 24, white: true),
        ),
        const SizedBox(height: 22),
        Text(
          'Transfa & You...',
          style: AppTypography.displayMedium.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'When you create your new Transfa Account, you give Transfa the explicit right to access, learn about, keep, understand, connect your financial footprint, process, and use your info to set up your Transfa, personalize your experience, and improve Transfa\'s services.',
          style: AppTypography.body.copyWith(
            fontSize: 17,
            color: AppColors.textPrimary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Transfa does not sell info.',
          style: AppTypography.body.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 17,
            color: AppColors.textPrimary,
            height: 1.5,
          ),
        ),
      ],
    ),
  );
}

class _PrivacyItem {
  final IconData icon;
  final String label;
  const _PrivacyItem(this.icon, this.label);
}

class _PrivacyRow extends StatelessWidget {
  final _PrivacyItem item;
  const _PrivacyRow(this.item);

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(item.icon, color: Colors.black, size: 20),
      const SizedBox(width: 10),
      Flexible(
        child: Text(
          item.label,
          style: AppTypography.body.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ],
  );
}

class _BackFab extends StatelessWidget {
  final VoidCallback onTap;
  const _BackFab({required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
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
