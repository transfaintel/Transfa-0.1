import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/assets.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/pill_button.dart';
import '../../../shared/widgets/transfa_logo.dart';

/// Onboarding feature list: CashDrop, Live Life, Pay Suppliers.
/// Top hero shows the "t" logo surrounded by faded orbiting brand icons.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _orbit = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 24),
  )..repeat();

  @override
  void dispose() {
    _orbit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundAlt,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 8, 28, 32),
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: AnimatedBuilder(
                  animation: _orbit,
                  builder: (_, _) => _OrbitHero(angle: _orbit.value * 2 * pi),
                ),
              ),
              const Expanded(flex: 6, child: _FeatureList()),
              PillButton(
                label: 'Get Started',
                onPressed: () => {
                  context.pop(),
                  context.push(Routes.register)
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrbitHero extends StatelessWidget {
  final double angle;
  const _OrbitHero({required this.angle});

  @override
  Widget build(BuildContext context) {
    // Faded floating brand bubbles around the central "t" mark.
    final orbitIcons = const [
      _OrbitIcon(asset: Assets.cashDrop, color: Color(0x33007AFF)),
      _OrbitIcon(asset: Assets.spendCurrency, color: Color(0x3307B826)),
      _OrbitIcon(asset: Assets.countryFlags, color: Color(0x33FF9F0A)),
      _OrbitIcon(asset: Assets.verifiedWorldwide, color: Color(0x3300C2FF)),
      _OrbitIcon(asset: Assets.privacy, color: Color(0x33F41E42)),
      _OrbitIcon(asset: Assets.transfaWallet, color: Color(0x33CB6BBA)),
    ];
    return LayoutBuilder(
      builder: (_, c) {
        final r = min(c.maxWidth, c.maxHeight) * 0.30;
        return Stack(
          alignment: Alignment.center,
          children: [
            for (var i = 0; i < orbitIcons.length; i++)
              Transform.translate(
                offset: Offset(
                  r * cos(angle + i * (2 * pi / orbitIcons.length)),
                  r * sin(angle + i * (2 * pi / orbitIcons.length)),
                ),
                child: Opacity(opacity: 0.35, child: orbitIcons[i]),
              ),
            const TransfaLogo(size: 84),
          ],
        );
      },
    );
  }
}

class _OrbitIcon extends StatelessWidget {
  final String asset;
  final Color color;
  const _OrbitIcon({required this.asset, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(8),
      child: SvgPicture.asset(asset, fit: BoxFit.contain),
    );
  }
}

class _FeatureList extends StatelessWidget {
  const _FeatureList();

  @override
  Widget build(BuildContext context) {
    const items = [
      _Feature(
        asset: Assets.cashDropBlue,
        title: 'CashDrop',
        subtitle: 'Your face is your account number.',
      ),
      _Feature(
        asset: Assets.spendCurrency,
        title: 'Live Life',
        subtitle: 'Travel, study, and shop in Naira.',
      ),
      _Feature(
        asset: Assets.China_Flag,
        title: 'Pay Suppliers',
        subtitle:
            'Pay Chinese suppliers & global businesses directly from your Naira balance.',
      ),
    ];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: items
          .map(
            (f) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: f,
            ),
          )
          .toList(),
    );
  }
}

class _Feature extends StatelessWidget {
  final String asset;
  final String title;
  final String subtitle;
  const _Feature({
    required this.asset,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title == 'Pay Suppliers'
            ? Padding(
                padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: SvgPicture.asset(asset, fit: BoxFit.contain),
                ),
              )
            : Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: SvgPicture.asset(asset, fit: BoxFit.contain),
                ),
              ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.headingLarge.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
