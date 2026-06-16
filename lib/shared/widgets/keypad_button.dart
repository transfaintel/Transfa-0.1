import 'package:flutter/material.dart';

import '../../core/theme/app_typography.dart';

/// Frosted glass circular keypad button (iOS lockscreen style).
class KeypadButton extends StatefulWidget {
  final String digit;
  final VoidCallback onTap;
  const KeypadButton({super.key, required this.digit, required this.onTap});

  @override
  State<KeypadButton> createState() => _KeypadButtonState();
}

class _KeypadButtonState extends State<KeypadButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: 78,
        height: 78,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: _pressed ? 0.55 : 0.25),
          border: Border.all(color: Colors.white.withValues(alpha: 0.45), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            widget.digit,
            style: AppTypography.displayMedium.copyWith(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
