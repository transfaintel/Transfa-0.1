import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/repositories/repositories.dart';
import '../../../shared/widgets/primary_button.dart';

/// Pop-up surface (#9) with the user's dedicated virtual account details
/// for funding the NGN wallet.
class VirtualAccountSheet extends ConsumerWidget {
  const VirtualAccountSheet({super.key});

  static Future<void> show(BuildContext context) => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const VirtualAccountSheet(),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dvaAsync = ref.watch(dvaProvider);
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Add money', style: AppTypography.headingLarge),
          const SizedBox(height: 6),
          Text('Transfer to this account from any Nigerian bank to fund your wallet instantly.',
              style: AppTypography.bodyMuted),
          const SizedBox(height: 24),
          dvaAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Text('Could not load account: $e'),
            data: (dva) => Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Row(label: 'Bank', value: dva.bankName),
                  const SizedBox(height: 12),
                  _Row(label: 'Account name', value: dva.accountName),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(child: _Row(label: 'Account number', value: dva.accountNumber, mono: true)),
                      TextButton.icon(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: dva.accountNumber));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Account number copied')),
                          );
                        },
                        icon: const Icon(Icons.copy_rounded, size: 18, color: AppColors.primary),
                        label: Text('Copy',
                            style: AppTypography.bodyStrong.copyWith(color: AppColors.primary)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(label: 'Done', onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool mono;
  const _Row({required this.label, required this.value, this.mono = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.caption),
        const SizedBox(height: 4),
        Text(value,
            style: AppTypography.subheading.copyWith(
              letterSpacing: mono ? 2 : null,
              fontFeatures: mono ? const [FontFeature.tabularFigures()] : null,
            )),
      ],
    );
  }
}
