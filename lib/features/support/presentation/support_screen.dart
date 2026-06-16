import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/primary_button.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: const Text('Support')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          Text('We\'re here to help. Reach us anytime.', style: AppTypography.bodyMuted),
          const SizedBox(height: 20),
          ..._channels.map((c) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(c.$1, color: AppColors.primary),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c.$2, style: AppTypography.bodyStrong),
                          Text(c.$3, style: AppTypography.caption),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                  ],
                ),
              )),
          const SizedBox(height: 12),
          Text('Send us a message', style: AppTypography.subheading),
          const SizedBox(height: 12),
          const AppInput(label: 'Subject', hint: 'What do you need help with?'),
          const SizedBox(height: 12),
          const AppInput(label: 'Message', hint: 'Tell us more…'),
          const SizedBox(height: 20),
          PrimaryButton(label: 'Send message', onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Thanks — we\'ll get back to you shortly.')),
            );
          }),
        ],
      ),
    );
  }
}

const _channels = [
  (Icons.chat_bubble_outline_rounded, 'Live chat', 'Average response under 2 minutes'),
  (Icons.mail_outline_rounded, 'Email us', 'support@transfa.app'),
  (Icons.phone_in_talk_outlined, 'Call support', '+234 800 800 8000'),
];
