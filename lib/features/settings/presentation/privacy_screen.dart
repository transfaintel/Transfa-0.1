import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/routes.dart';
import '../../../core/constants/assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';


class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool _cashDropContacts = true;
  bool _moneypoint = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 120),
              children: [
                GlassCard(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
                  radius: 32,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(Assets.privacy, width: 60, height: 60),
                      const SizedBox(height: 12),
                      Text('Privacy',
                          style: AppTypography.displayLarge.copyWith(
                              fontSize: 28, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Text('See the info we use & how your data\nis managed.',
                          style: AppTypography.body.copyWith(fontSize: 17)),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                _ToggleTile(
                  icon: const _BlueAppTile(icon: Icons.person_add_rounded),
                  label: 'CashDrop Contacts',
                  value: _cashDropContacts,
                  onChanged: (v) => setState(() => _cashDropContacts = v),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                      'Allow CashDrop to automatically save\nTransfa Accounts to contacts.',
                      style: AppTypography.body.copyWith(
                          color: AppColors.textMuted, fontSize: 15)),
                ),
                const SizedBox(height: 32),
                _ChevronTile(
                  icon: SizedBox(
                    width: 28, height: 28,
                    child: SvgPicture.asset(Assets.moneyLimits, fit: BoxFit.contain),
                  ),
                  label: 'Money Limits',
                  onTap: () => context.push(Routes.limits),
                ),
                const SizedBox(height: 40),
                _ToggleTile(
                  icon: SizedBox(
                    width: 30, height: 30,
                    child: SvgPicture.asset(Assets.moneypoint, fit: BoxFit.contain),
                  ),
                  label: 'Moneypoint',
                  value: _moneypoint,
                  onChanged: (v) => setState(() => _moneypoint = v),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                      'Moneypoint uses GPS, Bluetooth, payment history, and crowd-sourced Wi-Fi hotspot and cell tower signals to determine your location.',
                      style: AppTypography.body.copyWith(
                          color: AppColors.textMuted, fontSize: 15)),
                ),
                const SizedBox(height: 22),
                // Combined card for Privacy Policy and Legal
                _CombinedChevronCard(
                  items: [
                    ChevronItem(
                      icon: const _GreenAppTile(icon: Icons.privacy_tip_rounded),
                      label: 'Privacy Policy',
                      onTap: () => context.push(Routes.privacyPolicy),
                    ),
                    ChevronItem(
                      icon: SvgPicture.asset(Assets.verifiedWorldwide, width: 28, height: 28, fit: BoxFit.contain),
                      label: 'Legal',
                      onTap: () => context.push(Routes.legal),
                    ),
                  ],
                ),
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
  }
}

class _ToggleTile extends StatelessWidget {
  final Widget icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _ToggleTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 4),
          SizedBox(width: 30, height: 30, child: Center(child: icon)),
          const SizedBox(width: 14),
          Expanded(
            child: Text(label,
                style: AppTypography.subheading.copyWith(fontSize: 17)),
          ),
          Switch.adaptive(
            value: value,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.success,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _ChevronTile extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback onTap;
  const _ChevronTile({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        height: 68,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(width: 44, height: 44, child: Center(child: icon)),
            const SizedBox(width: 5),
            Expanded(
              child: Text(label,
                  style: AppTypography.subheading.copyWith(fontSize: 17)),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textMuted, size: 26),
          ],
        ),
      ),
    );
  }
}

class _CombinedChevronCard extends StatelessWidget {
  final List<ChevronItem> items;
  const _CombinedChevronCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Column(
            children: [
              InkWell(
                onTap: item.onTap,
                borderRadius: BorderRadius.vertical(
                  top: index == 0 ? const Radius.circular(40) : Radius.zero,
                  bottom: index == items.length - 1 ? const Radius.circular(40) : Radius.zero,
                ),
                child: Container(
                  height: 68,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.vertical(
                      top: index == 0 ? const Radius.circular(40) : Radius.zero,
                      bottom: index == items.length - 1 ? const Radius.circular(40) : Radius.zero,
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 44, height: 44, child: Center(child: item.icon)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item.label,
                          style: AppTypography.subheading.copyWith(fontSize: 17),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.textMuted,
                        size: 26,
                      ),
                    ],
                  ),
                ),
              ),
              if (index < items.length - 1)
                const Divider(
                  height: 1,
                  color: Color(0xFFE0E0E0),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class ChevronItem {
  final Widget icon;
  final String label;
  final VoidCallback onTap;

  ChevronItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

class _BlueAppTile extends StatelessWidget {
  final IconData icon;
  const _BlueAppTile({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30, height: 30,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00C2FF), Color(0xFF006EFF)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }
}

class _GreenAppTile extends StatelessWidget {
  final IconData icon;
  const _GreenAppTile({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30, height: 30,
      decoration: BoxDecoration(
        color: AppColors.success,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }
}

class _BackFab extends StatelessWidget {
  final VoidCallback onTap;
  const _BackFab({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56, height: 56,
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
        child: const Icon(Icons.chevron_left_rounded,
            color: Color(0xFFFF375F), size: 28),
      ),
    );
  }
}