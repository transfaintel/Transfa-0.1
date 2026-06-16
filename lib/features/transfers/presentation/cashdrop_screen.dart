import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/assets.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/mock_api/mock_data.dart';
import '../../../data/repositories/repositories.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/modal_scaffold.dart';
import '../../../shared/widgets/pill_button.dart';
import '../../../shared/widgets/transfa_logo.dart';

/// CashDrop landing — large photo card with the user's portrait and a
/// dark "Transfa" pill to drop into the scan flow. Mirrors the "CashDrop
/// profile" screenshot.
class CashDropScreen extends ConsumerWidget {
  const CashDropScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider) ?? MockData.currentUser;
    return ModalScaffold(
      horizontalPadding: 24,
      child: GlassCard(
              padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00C2FF), Color(0xFF006EFF)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: SvgPicture.asset(Assets.cashDrop),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'CashDrop',
                        style: AppTypography.displayMedium.copyWith(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.black.withValues(alpha: 0.08)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.grey,
                    backgroundImage: const AssetImage(Assets.magic),
                  ),
                  const SizedBox(height: 24),
                  Text(user.fullName,
                      style: AppTypography.displayMedium.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.black.withValues(alpha: 0.12))),
                  const SizedBox(height: 28),
                  PillButton(
                    label: 'Transfa',
                    variant: PillVariant.dark,
                    leading: const TransfaMark(size: 22, white: true),
                    onPressed: () => context.push(Routes.cashDropScan),
                  ),
                  const SizedBox(height: 8),
                  Opacity(
                    opacity: 0.35,
                    child: PillButton(
                      label: 'Save',
                      variant: PillVariant.secondary,
                      leading: const Icon(Icons.person_add_rounded,
                          color: Colors.white, size: 20),
                      onPressed: () {},
                    ),
                  ),
              ],
            ),
          ),
        );
  }
}
