import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/assets.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/modal_scaffold.dart';
import '../../../shared/widgets/pill_button.dart';

/// Error / re-entry surface shown when the chosen ID can't be verified.
/// Modal card hovering over the dimmed home wallpaper.
class UnsupportedIdScreen extends StatelessWidget {
  const UnsupportedIdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModalScaffold(
      child: GlassCard(
        padding: const EdgeInsets.fromLTRB(28, 28, 28, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(Assets.photoId, height: 48),
            const SizedBox(height: 22),
            Text('Unsupported ID',
                style: AppTypography.displayMedium
                    .copyWith(fontWeight: FontWeight.w800, fontSize: 28)),
            const SizedBox(height: 12),
            Text(
              'To continue, pick a Photo\nID, enter your NIN, then add\na clear picture of your\nPhoto ID and verify.',
              style: AppTypography.body.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 26),
            PillButton(label: 'Continue', onPressed: () => context.pop()),
            const SizedBox(height: 10),
            PillButton(
              label: 'Photo ID Guide',
              variant: PillVariant.secondary,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
