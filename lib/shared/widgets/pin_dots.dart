import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// 4 or 6 dot indicator for PIN entry screens.
class PinDots extends StatelessWidget {
  final int length;
  final int filled;
  const PinDots({super.key, required this.length, required this.filled});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (i) {
        final isFilled = i < filled;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          width: isFilled ? 18 : 14,
          height: isFilled ? 18 : 14,
          decoration: BoxDecoration(
            color: isFilled ? AppColors.primary : Colors.transparent,
            border: Border.all(color: AppColors.primary, width: 1.4),
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}
