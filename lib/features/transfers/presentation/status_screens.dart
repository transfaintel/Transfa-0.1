import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/modal_scaffold.dart';
import '../../../shared/widgets/transfa_modal_header.dart';

/// Status modal — shows after a payment lands in one of three states:
/// failed (red), pending (orange + progress bar), succeeded (green).
class _StatusShell extends StatelessWidget {
  final Color avatarColor;
  final String name;
  final String account;
  final String headline;
  final String amountColored;
  final Color amountColor;
  final bool amountStruckThrough;
  final String memoLabel;
  final String description;
  final Widget? footer;

  const _StatusShell({
    required this.avatarColor,
    required this.name,
    required this.account,
    required this.headline,
    required this.amountColored,
    required this.amountColor,
    required this.amountStruckThrough,
    required this.memoLabel,
    required this.description,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return ModalScaffold(
      child: GlassCard(
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TransfaModalHeader(title: 'Status', onClose: () => context.pop()),
            const SizedBox(height: 32),
            Center(
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [avatarColor, avatarColor.withValues(alpha: 0.85)],
                  ),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.person_rounded, color: Colors.white, size: 80),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(name,
                  style: AppTypography.displayLarge
                      .copyWith(fontSize: 36, fontWeight: FontWeight.w800)),
            ),
            const SizedBox(height: 6),
            Center(
              child: Text(account,
                  style: AppTypography.subheading
                      .copyWith(color: AppColors.textMuted, fontSize: 20)),
            ),
            const SizedBox(height: 28),
            Center(
              child: Text(headline,
                  style: AppTypography.subheading
                      .copyWith(color: AppColors.textMuted, fontSize: 20)),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                amountColored,
                style: AppTypography.displayLarge.copyWith(
                  fontSize: 44,
                  fontWeight: FontWeight.w800,
                  color: amountColor,
                  decoration: amountStruckThrough ? TextDecoration.lineThrough : null,
                  decorationColor: amountColor.withValues(alpha: 0.5),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Center(
              child: Text(memoLabel,
                  style: AppTypography.subheading
                      .copyWith(color: AppColors.textMuted, fontSize: 19)),
            ),
            const SizedBox(height: 28),
            if (footer != null) ...[footer!, const SizedBox(height: 18)],
            Text(description,
                style: AppTypography.body
                    .copyWith(fontSize: 17, color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}

/// Failed payment — orange avatar, "Unable to send" headline, struck-through amount.
class StatusUnableScreen extends StatelessWidget {
  const StatusUnableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _StatusShell(
      avatarColor: Color(0xFFFF9F0A),
      name: 'Amadioha',
      account: '207 922 3313',
      headline: 'Unable to send',
      amountColored: '₦277,500',
      amountColor: Color(0xFF8E8E93),
      amountStruckThrough: true,
      memoLabel: 'for "Goof".',
      description:
          'The money could not be sent because\n"Wema" is unavailable. Try again in a\nfew minutes. Transfa Accounts are\nalways available.',
    );
  }
}

/// Pending payment — red avatar, orange amount + orange progress bar.
class StatusProcessingScreen extends StatelessWidget {
  const StatusProcessingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _StatusShell(
      avatarColor: const Color(0xFFFF375F),
      name: 'Amadioha',
      account: '207 922 3313',
      headline: "Processing by receiver's bank",
      amountColored: '₦277,500',
      amountColor: const Color(0xFFFF9F0A),
      amountStruckThrough: false,
      memoLabel: 'for "Goof".',
      footer: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Color(0xFFFF9F0A),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.access_time_filled_rounded,
                color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: const LinearProgressIndicator(
                value: 0.7,
                minHeight: 8,
                backgroundColor: Color(0xFFEEEEEE),
                color: Color(0xFFFF9F0A),
              ),
            ),
          ),
        ],
      ),
      description:
          'The money has been sent and is being\nprocessed by "Wema". Payments arrive\nwithin minutes. Transfa Accounts\nreceive money instantly.',
    );
  }
}

/// Success — blue building avatar (recipient is a business), green amount.
class StatusSentScreen extends StatelessWidget {
  const StatusSentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _StatusShell(
      avatarColor: Color(0xFF1EA7FF),
      name: 'Uptown',
      account: '207 922 3313',
      headline: 'Sent to Uptown',
      amountColored: '₦277,500',
      amountColor: Color(0xFF07B826),
      amountStruckThrough: true,
      memoLabel: 'for "Jewelry".',
      description:
          'The money has been received by\n"Wema" and the receiver\'s account is\nexpected to be credited within 5\nminutes. Transfa AI is coming.',
    );
  }
}
