import 'dart:math';
import '../../../core/theme/app_colors.dart';

import 'package:flutter/material.dart';

/// The signature "rainbow dot ring" used on every CashDrop scan screen.
/// 50 dots arranged in a circle, colored in 4 brand-arc segments:
/// blue (top), red (right), orange (bottom), green (left), with a tiny
/// purple dot at the splice point. Optional child renders inside.
class RainbowFaceRing extends StatelessWidget {
  final double size;
  final Widget? child;
  final bool pulse;
  const RainbowFaceRing({
    super.key,
    this.size = 320,
    this.child,
    this.pulse = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(size: Size.square(size), painter: _RingPainter()),
          if (child != null)
            ClipOval(
              child: SizedBox(
                width: size * 0.66,
                height: size * 0.66,
                child: child,
              ),
            ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  static const _total = 50;

  // Brand quadrants (top → right → bottom → left).
  static const _segments = [
    (count: 14, color: Color(0xFF1EA7FF)), // blue (top)
    (count: 11, color: Color(0xFFFF375F)), // red (right)
    (count: 13, color: Color(0xFFFF9F0A)), // orange (bottom)
    (count: 11, color: AppColors.success), // green (left)
    (count: 1, color: Color(0xFFAF52DE)), // tiny purple splice
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2 - 16;

    final dotColors = <Color>[];
    for (final s in _segments) {
      for (var i = 0; i < s.count; i++) {
        dotColors.add(s.color);
      }
    }
    while (dotColors.length < _total) {
      dotColors.add(_segments.first.color);
    }

    for (var i = 0; i < _total; i++) {
      final angle = -pi / 2 + (i / _total) * 2 * pi;
      final p = Offset(c.dx + r * cos(angle), c.dy + r * sin(angle));
      final paint = Paint()..color = dotColors[i % dotColors.length];
      canvas.drawCircle(p, 8, paint);
    }
    // Inner face plate.
    canvas.drawCircle(c, r - 22, Paint()..color = const Color(0xFFE9E9E9));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
