import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/modal_scaffold.dart';
import '../../../shared/widgets/pill_button.dart';

/// "Where do you live?" — modal card with green location pin, description,
/// inline toggle and orange Continue button.
class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  bool _enabled = false;

  @override
  Widget build(BuildContext context) {
    return ModalScaffold(
      child: GlassCard(
        padding: const EdgeInsets.fromLTRB(28, 28, 28, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4EE659), Color(0xFF07B826)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.10),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.place_rounded, size: 36, color: Colors.white),
            ),
            const SizedBox(height: 22),
            Text('Where do you live?',
                style: AppTypography.displayMedium
                    .copyWith(fontWeight: FontWeight.w800, fontSize: 28)),
            const SizedBox(height: 10),
            Text(
              'To verify your home\ninstantly, Turn On Location\nServices.',
              style: AppTypography.body.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFB347), Color(0xFFFF7A00)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.navigation_rounded, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 12),
                Text('Location', style: AppTypography.subheading),
                const Spacer(),
                Switch.adaptive(
                  value: _enabled,
                  onChanged: (v) => setState(() => _enabled = v),
                ),
              ],
            ),
            const SizedBox(height: 22),
            PillButton(
              label: 'Continue',
              variant: PillVariant.orange,
              onPressed: () => context.push(Routes.register),
            ),
          ],
        ),
      ),
    );
  }
}
