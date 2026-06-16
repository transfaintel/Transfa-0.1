import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/transaction.dart';
import '../../../data/repositories/repositories.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/primary_button.dart';
import 'transfer_state.dart';

class TransferDetailsScreen extends ConsumerStatefulWidget {
  const TransferDetailsScreen({super.key});

  @override
  ConsumerState<TransferDetailsScreen> createState() => _TransferDetailsScreenState();
}

class _TransferDetailsScreenState extends ConsumerState<TransferDetailsScreen> {
  final _name = TextEditingController();
  final _account = TextEditingController();
  final _bank = TextEditingController();
  final _memo = TextEditingController();
  bool _loading = false;

  bool get _isUsd => ref.read(transferDraftProvider).currency == TxCurrency.usd;

  @override
  void initState() {
    super.initState();
    final d = ref.read(transferDraftProvider);
    _name.text = d.recipientName ?? '';
    _account.text = d.recipientAccount ?? '';
    _bank.text = d.bankName ?? '';
    _memo.text = d.memo ?? '';
  }

  @override
  void dispose() {
    _name.dispose();
    _account.dispose();
    _bank.dispose();
    _memo.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    final draft = ref.read(transferDraftProvider);
    if (draft.amount == null) return;
    setState(() => _loading = true);
    final repo = ref.read(transferRepositoryProvider);
    final quote = draft.currency == TxCurrency.usd
        ? await repo.quoteUsd(draft.amount!)
        : await repo.quoteNgn(draft.amount!);

    ref.read(transferDraftProvider.notifier).state = draft.copyWith(
      recipientName: _name.text.trim(),
      recipientAccount: _account.text.trim(),
      bankName: _bank.text.trim(),
      memo: _memo.text.trim(),
      quote: quote,
    );
    if (!mounted) return;
    setState(() => _loading = false);
    context.push(Routes.transferConfirm);
  }

  @override
  Widget build(BuildContext context) {
    final isUsd = _isUsd;
    return AppScaffold(
      appBar: AppBar(title: const Text('Recipient')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          Text(isUsd ? 'Who is receiving the USD payout?' : 'Who are you sending to?',
              style: AppTypography.bodyMuted),
          const SizedBox(height: 24),
          AppInput(
            label: 'Recipient name',
            hint: 'Full name',
            controller: _name,
            capitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 16),
          AppInput(
            label: isUsd ? 'Stablecoin / USD payout address' : 'Account number',
            hint: isUsd ? 'USDC / USDT address or bank' : '10-digit account number',
            controller: _account,
            keyboardType: isUsd ? TextInputType.text : TextInputType.number,
          ),
          const SizedBox(height: 16),
          AppInput(
            label: isUsd ? 'Network / Bank' : 'Bank',
            hint: isUsd ? 'Polygon, Tron, Wire…' : 'Choose bank',
            controller: _bank,
          ),
          const SizedBox(height: 16),
          AppInput(label: 'Memo', hint: 'Optional note', controller: _memo),
          const SizedBox(height: 28),
          PrimaryButton(
            label: 'Continue',
            loading: _loading,
            onPressed: _name.text.trim().isEmpty || _account.text.trim().isEmpty ? null : _next,
          ),
        ],
      ),
    );
  }
}
