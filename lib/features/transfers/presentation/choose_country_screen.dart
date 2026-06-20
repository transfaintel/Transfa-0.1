import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../data/mock_api/currency.dart';

class SendMoneyWherePage extends StatelessWidget {
  const SendMoneyWherePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main scrollable content
          SizedBox(
            width: 390,
            height: 1750,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Main content with padding
                  Container(
                    padding: const EdgeInsets.only(top: 72, bottom: 202, left: 20, right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Header Glass Card
                        _buildHeaderCard(),
                        const SizedBox(height: 40),

                        // Top Countries Section
                        _buildTopCountriesSection(context),
                        const SizedBox(height: 20),

                        // All Countries Section
                        _buildAllCountriesSection(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Close button positioned at bottom right
          Positioned(
            bottom: 20,
            right: 20,
            child: _CloseFab(onTap: () => context.pop()),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: 330,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFCFB).withOpacity(0.3),
        borderRadius: BorderRadius.circular(35),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Board Buttons/Country
          Container(
            width: 60,
            height: 60,
            child: SvgPicture.asset(
              Assets.countryGreen,
              width: 24,
              height: 24,
            ),
          ),
          const SizedBox(width: 20),
          // Storyline
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Send Money Where?',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.56,
                    color: Colors.black,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Choose the receiver\'s country.',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.34,
                    color: Colors.black.withOpacity(0.7),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopCountriesSection(BuildContext context) {
    return Container(
      width: 350,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Navigation Header
          Container(
            width: 350,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  child: SvgPicture.asset(Assets.star),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Text(
                    'Top Countries',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.4,
                      color: Colors.black,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // Top Countries List Container
          Container(
            width: 350,
            decoration: BoxDecoration(
              color: const Color(0xFFFCFCFB),
              borderRadius: BorderRadius.circular(35),
            ),
            child: Column(
              children: [
                _buildCountryRow(
                  context,
                  flagWidget: _buildUSAFlag(),
                  name: 'United States',
                  code: 'USD',
                  flagAsset: Assets.spendCurrency,
                  currency: AmountCurrency.usd,
                  hasCheck: false,
                ),
                const _SlimDivider(),
                _buildCountryRow(
                  context,
                  flagWidget: _buildNigeriaFlag(),
                  name: 'Nigeria',
                  code: 'NGN',
                  flagAsset: Assets.Nigerian_Flag,
                  currency: AmountCurrency.ngn,
                  hasCheck: true,
                ),
                const _SlimDivider(),
                _buildCountryRow(
                  context,
                  flagWidget: _buildUKFlag(),
                  name: 'United Kingdom',
                  code: 'GBP',
                  flagAsset: Assets.UKFlags,
                  currency: AmountCurrency.usd, // Default to USD if not available
                  hasCheck: false,
                ),
                const _SlimDivider(),
                _buildCountryRow(
                  context,
                  flagWidget: _buildRwandaFlag(),
                  name: 'Rwanda',
                  code: 'RWF',
                  flagAsset: Assets.rwandaFlag,
                  currency: AmountCurrency.usd, // Default to USD if not available
                  hasCheck: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllCountriesSection(BuildContext context) {
    return Container(
      width: 350,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // All Countries Header
          Container(
            width: 350,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  child: SvgPicture.asset(Assets.globe),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Text(
                    'All Countries',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.4,
                      color: Colors.black,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // All Countries List Container
          Container(
            width: 350,
            decoration: BoxDecoration(
              color: const Color(0xFFFCFCFB),
              borderRadius: BorderRadius.circular(35),
            ),
            child: Column(
              children: [
                _buildCountryRow(
                  context,
                  flagWidget: _buildUSAFlag(),
                  name: 'United States',
                  code: 'USD',
                  flagAsset: Assets.spendCurrency,
                  currency: AmountCurrency.usd,
                  hasCheck: false,
                ),
                const _SlimDivider(),
                _buildCountryRow(
                  context,
                  flagWidget: _buildNigeriaFlag(),
                  name: 'Nigeria',
                  code: 'NGN',
                  flagAsset: Assets.Nigerian_Flag,
                  currency: AmountCurrency.ngn,
                  hasCheck: false,
                ),
                const _SlimDivider(),
                _buildCountryRow(
                  context,
                  flagWidget: _buildUKFlag(),
                  name: 'United Kingdom',
                  code: 'GBP',
                  flagAsset: Assets.UKFlags,
                  currency: AmountCurrency.usd,
                  hasCheck: false,
                ),
                const _SlimDivider(),
                _buildCountryRow(
                  context,
                  flagWidget: _buildRwandaFlag(),
                  name: 'Rwanda',
                  code: 'RWF',
                  flagAsset: Assets.rwandaFlag,
                  currency: AmountCurrency.usd,
                  hasCheck: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // More Countries - Ghana
          Container(
            width: 350,
            decoration: BoxDecoration(
              color: const Color(0xFFFCFCFB),
              borderRadius: BorderRadius.circular(35),
            ),
            child: Column(
              children: [
                _buildCountryRow(
                  context,
                  flagWidget: _buildChinaFlag(),
                  name: 'China',
                  code: 'CNY',
                  flagAsset: Assets.China_Flag,
                  currency: AmountCurrency.usd,
                  hasCheck: false,
                ),
                const _SlimDivider(),
                _buildCountryRow(
                  context,
                  flagWidget: _buildUSAFlag(),
                  name: 'United States',
                  code: 'USD',
                  flagAsset: Assets.spendCurrency,
                  currency: AmountCurrency.usd,
                  hasCheck: false,
                ),
                const _SlimDivider(),
                _buildCountryRow(
                  context,
                  flagWidget: _buildRwandaFlag(),
                  name: 'Rwanda',
                  code: 'RWF',
                  flagAsset: Assets.rwandaFlag,
                  currency: AmountCurrency.usd,
                  hasCheck: false,
                ),
                const _SlimDivider(),
                _buildCountryRow(
                  context,
                  flagWidget: _buildUKFlag(),
                  name: 'United Kingdom',
                  code: 'GBP',
                  flagAsset: Assets.UKFlags,
                  currency: AmountCurrency.usd,
                  hasCheck: false,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCountryRow(
    BuildContext context, {
    required Widget flagWidget,
    required String name,
    required String code,
    required String flagAsset,
    required AmountCurrency currency,
    required bool hasCheck,
  }) {
    return GestureDetector(
      onTap: () {
        // Return the selected country data
        Navigator.pop(context, {
          'name': name,
          'code': code,
          'flag': flagAsset,
          'currency': currency,
        });
      },
      child: Container(
        width: 338,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            flagWidget,
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.34,
                  color: Colors.black,
                  height: 1.5,
                ),
              ),
            ),
            
            if (hasCheck) ...[
              const SizedBox(width: 10),
              Container(
                width: 26,
                height: 26,
                child: const Icon(Icons.check, color: Color(0xFFF41E42), size: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Flag Widgets
  Widget _buildUSAFlag() {
    return Container(
      width: 32,
      height: 26,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      child: SvgPicture.asset(Assets.spendCurrency),
    );
  }

  Widget _buildNigeriaFlag() {
    return Container(
      width: 32,
      height: 26,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      child: SvgPicture.asset(Assets.Nigerian_Flag),
    );
  }

  Widget _buildUKFlag() {
    return Container(
      width: 32,
      height: 26,
      child: SvgPicture.asset(Assets.UKFlags),
    );
  }

  Widget _buildRwandaFlag() {
    return Container(
      width: 32,
      height: 26,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
      ),
      child: SvgPicture.asset(Assets.rwandaFlag),
    );
  }

  Widget _buildChinaFlag() {
    return Container(
      width: 32,
      height: 26,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
      ),
      child: SvgPicture.asset(Assets.China_Flag),
    );
  }
}

class _SlimDivider extends StatelessWidget {
  const _SlimDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 310,
      height: 1,
      color: Colors.black.withOpacity(0.03),
    );
  }
}

class _CloseFab extends StatelessWidget {
  final VoidCallback onTap;
  const _CloseFab({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
          Icons.close_rounded,
          color: Colors.black,
          size: 28,
        ),
      ),
    );
  }
}