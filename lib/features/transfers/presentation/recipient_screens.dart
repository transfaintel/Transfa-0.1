import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/assets.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/transfa_logo.dart';
import '../../../shared/widgets/transfa_modal_header.dart';
import 'transfer_state.dart';

/// Recipient profile — single account variant (single bank choice).
class RecipientProfileScreen extends ConsumerWidget {
  const RecipientProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _RecipientShell(
      footer: _CardSection(
        body: 'This account number is connected to multiple banks, choose a bank to pay.',
        rows: const [
          _BankRow(asset: Assets.logoSmall, label: 'Transfa', showChevron: true),
        ],
      ),
      onTapRow: () => context.push(Routes.recipientAmountPreview),
    );
  }
}

/// Recipient profile — multi-bank variant.
class RecipientMultiBankScreen extends ConsumerWidget {
  const RecipientMultiBankScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _RecipientShell(
      footer: _CardSection(
        body: 'Magic has multiple bank accounts,\nchoose a bank to pay.',
        rows: const [
          _BankRow(asset: Assets.logoSmall, label: 'Transfa', showChevron: true),
          _BankRow(image: Assets.bankFcmb, label: 'FCMB', showChevron: true, divider: true),
        ],
      ),
      onTapRow: () => context.push(Routes.recipientAmountPreview),
    );
  }
}

/// Recipient profile — amount preview variant (after choosing a bank).
class RecipientAmountPreviewScreen extends ConsumerWidget {
  const RecipientAmountPreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(transferDraftProvider);
    final amount = draft.amount ?? 0;
    return _RecipientShell(
      showAccountNumber: false,
      footer: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFF1A1A1A),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const TransfaMark(size: 22, white: true),
              ),
              const SizedBox(width: 12),
              Text('Transfa',
                  style: AppTypography.subheading.copyWith(fontSize: 22)),
              const Spacer(),
              const Icon(Icons.unfold_more_rounded, color: AppColors.textMuted, size: 26),
            ],
          ),
          const SizedBox(height: 36),
          Text('Send Magic Payma',
              style: AppTypography.subheading
                  .copyWith(color: AppColors.textMuted, fontSize: 22)),
          const SizedBox(height: 6),
          RichText(
            text: TextSpan(
              style: AppTypography.displayLarge.copyWith(
                fontSize: 56,
                fontWeight: FontWeight.w800,
                color: Colors.black,
                decoration: TextDecoration.lineThrough,
                decorationColor: Colors.black.withValues(alpha: 0.45),
              ),
              children: [
                const TextSpan(text: '₦'),
                TextSpan(text: _format(amount.truncate())),
                TextSpan(
                  text: '.${(amount.toStringAsFixed(2)).split('.').last}',
                  style: const TextStyle(fontSize: 28),
                ),
              ],
            ),
          ),
        ],
      ),
      onTapRow: () => context.push(Routes.receiptStatus),
    );
  }

  String _format(int v) {
    final s = v.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}

/// Common scaffold for recipient screens — header, big photo, name, then
/// a per-variant footer block.
class _RecipientShell extends StatelessWidget {
  final Widget footer;
  final bool showAccountNumber;
  final VoidCallback? onTapRow;

  const _RecipientShell({
    required this.footer,
    this.showAccountNumber = true,
    this.onTapRow,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TransfaModalHeader(onClose: () => context.pop()),
              const SizedBox(height: 32),
              Center(
                child: CircleAvatar(
                  radius: 78,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: const AssetImage(Assets.magic),
                ),
              ),
              const SizedBox(height: 18),
              Center(
                child: Text('Magic Payma',
                    style: AppTypography.displayMedium
                        .copyWith(fontWeight: FontWeight.w800, fontSize: 38)),
              ),
              if (showAccountNumber) ...[
                const SizedBox(height: 8),
                Center(
                  child: Text('207 922 3313',
                      style: AppTypography.subheading
                          .copyWith(color: AppColors.textMuted, fontSize: 22)),
                ),
              ],
              const SizedBox(height: 32),
              footer,
            ],
          ),
        ),
      ),
    );
  }
}

class _CardSection extends StatelessWidget {
  final String body;
  final List<_BankRow> rows;
  const _CardSection({required this.body, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(body, style: AppTypography.body.copyWith(fontSize: 20, height: 1.3)),
        const SizedBox(height: 24),
        ...rows,
      ],
    );
  }
}

class _BankRow extends StatelessWidget {
  final String? asset;
  final String? image;
  final String label;
  final bool showChevron;
  final bool divider;

  const _BankRow({
    this.asset,
    this.image,
    required this.label,
    this.showChevron = false,
    this.divider = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (divider) const Divider(color: Color(0xFFE0E0E0)),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            children: [
              SizedBox(
                width: 36,
                height: 36,
                child: image != null
                    ? ClipOval(child: Image.asset(image!, fit: BoxFit.cover))
                    : const Center(child: TransfaMark(size: 30)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(label,
                    style: AppTypography.subheading.copyWith(fontSize: 22)),
              ),
              if (showChevron)
                const Icon(Icons.chevron_right_rounded,
                    color: AppColors.textMuted, size: 28),
            ],
          ),
        ),
      ],
    );
  }
}
