import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/modal_scaffold.dart';
import '../../../shared/widgets/transfa_logo.dart';

enum AmountCurrency {
  ngn(symbol: '₦', code: 'NGN', label: 'Naira'),
  usd(symbol: '\$', code: 'USD', label: 'Dollar');

  final String symbol;
  final String code;
  final String label;
  const AmountCurrency({required this.symbol, required this.code, required this.label});
}

/// "Amount Currency" picker — Dollar + Naira rows with flags.
/// Returns the chosen [AmountCurrency] via Navigator.pop.
class AmountCurrencyScreen extends StatelessWidget {
  const AmountCurrencyScreen({super.key});

  static Future<AmountCurrency?> push(BuildContext context) =>
      Navigator.of(context).push<AmountCurrency>(
        PageRouteBuilder(
          opaque: false,
          barrierColor: Colors.black.withValues(alpha: 0.35),
          pageBuilder: (_, _, _) => const AmountCurrencyScreen(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ModalScaffold(
      child: GlassCard(
        padding: const EdgeInsets.fromLTRB(24, 26, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: const TransfaMark(size: 32, white: true),
            ),
            const SizedBox(height: 18),
            Text('Amount Currency',
                style: AppTypography.displayMedium
                    .copyWith(fontWeight: FontWeight.w800, fontSize: 26)),
            const SizedBox(height: 8),
            Text(
              'Select a currency to enter the\namount. Transfa converts\nautomatically.',
              style: AppTypography.body.copyWith(color: AppColors.textMuted, fontSize: 18),
            ),
            const SizedBox(height: 22),
            _CurrencyRow(
              flag: _UsFlag(),
              label: 'Dollar',
              onTap: () => Navigator.of(context).pop(AmountCurrency.usd),
            ),
            const SizedBox(height: 10),
            _CurrencyRow(
              flag: _NigeriaFlag(),
              label: 'Naira',
              onTap: () => Navigator.of(context).pop(AmountCurrency.ngn),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurrencyRow extends StatelessWidget {
  final Widget flag;
  final String label;
  final VoidCallback onTap;
  const _CurrencyRow({required this.flag, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(width: 44, height: 32, child: flag),
            const SizedBox(width: 14),
            Text(label, style: AppTypography.subheading.copyWith(fontSize: 22)),
          ],
        ),
      ),
    );
  }
}

class _NigeriaFlag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: const Row(
        children: [
          Expanded(child: ColoredBox(color: Color(0xFF008751))),
          Expanded(child: ColoredBox(color: Colors.white)),
          Expanded(child: ColoredBox(color: Color(0xFF008751))),
        ],
      ),
    );
  }
}

class _UsFlag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Stack(
        children: [
          Column(
            children: List.generate(
              7,
              (i) => Expanded(
                child: ColoredBox(
                  color: i.isEven ? const Color(0xFFB22234) : Colors.white,
                ),
              ),
            ),
          ),
          Container(
            width: 18,
            height: 17,
            color: const Color(0xFF3C3B6E),
          ),
        ],
      ),
    );
  }
}
