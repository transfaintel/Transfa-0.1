import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/assets.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/repositories/repositories.dart';
import '../../../shared/widgets/transfa_logo.dart';
import '../../../shared/widgets/wallpaper_scaffold.dart';

/// Frosted "Wallet" surface that hovers over the dimmed home wallpaper.
/// Mirrors the second wallet screenshot — large balance card on top and
/// an Add Money card with Copy/Share/CashDrop pills below.
class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallet = ref.watch(walletProvider);
    final dva = ref.watch(dvaProvider);
    final balance = wallet.maybeWhen(data: (w) => w.ngnBalance, orElse: () => 0.0);
    final accountNumber = dva.maybeWhen(data: (d) => d.accountNumber, orElse: () => '—');

    return WallpaperScaffold(
      darken: 0.55,
      blur: true,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        child: Column(
          children: [
            const Spacer(flex: 2),
            _BalanceWidget(balance: balance),
            const SizedBox(height: 18),
            _AddMoneyWidget(account: accountNumber),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}

class _BalanceWidget extends StatelessWidget {
  final double balance;
  const _BalanceWidget({required this.balance});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundImage: const AssetImage(Assets.magic),
                backgroundColor: Colors.grey,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Magic',
                        style: AppTypography.subheading.copyWith(
                          color: Colors.white.withValues(alpha: 0.20),
                          fontSize: 20,
                        )),
                    const SizedBox(height: 6),
                    Text('Transfa Balance',
                        style: AppTypography.caption.copyWith(
                          color: Colors.white.withValues(alpha: 0.40),
                          fontSize: 13,
                        )),
                    const SizedBox(height: 2),
                    RichText(
                      text: TextSpan(
                        style: AppTypography.displayLarge.copyWith(
                          color: Colors.white.withValues(alpha: 0.40),
                          fontSize: 40,
                          fontWeight: FontWeight.w300,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Colors.white.withValues(alpha: 0.3),
                        ),
                        children: [
                          const TextSpan(text: '₦'),
                          TextSpan(text: balance.truncate().toString()),
                          TextSpan(
                            text: '.${AppFormat.ngn(balance).split('.').last}',
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddMoneyWidget extends StatelessWidget {
  final String account;
  const _AddMoneyWidget({required this.account});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withValues(alpha: 0.32)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Center(child: TransfaMark(size: 26, white: true)),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Transfa',
                          style: AppTypography.caption.copyWith(
                              color: Colors.white.withValues(alpha: 0.55), fontSize: 14)),
                      Text(account.replaceAllMapped(
                            RegExp(r'(\d{3})(\d{3})(\d{4})'),
                            (m) => '${m[1]} ${m[2]} ${m[3]}',
                          ),
                          style: AppTypography.heading.copyWith(
                              color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ActionPill(label: 'Copy', svgAsset: Assets.copy),
                  _ActionPill(label: 'Share', svgAsset: Assets.share),
                  _ActionPill(label: 'CashDrop', svgAsset: Assets.cashDrop, bg: const Color(0xFF1976FF)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionPill extends StatelessWidget {
  final String label;
  final String svgAsset;
  final Color? bg;
  const _ActionPill({required this.label, required this.svgAsset, this.bg});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: bg ?? Colors.white.withValues(alpha: 0.18),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
          ),
          child: Center(
            child: SizedBox(
              width: 28,
              height: 28,
              child: SvgPicture.asset(svgAsset, fit: BoxFit.contain),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(label,
            style: AppTypography.body.copyWith(
                color: Colors.white.withValues(alpha: 0.55), fontSize: 14)),
      ],
    );
  }
}
