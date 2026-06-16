import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedDottedLoader extends StatefulWidget {
  final int dotCount;
  final double radius;
  final double dotSize;
  final Color activeColor;
  final List<Color> inactiveColors;
  final Duration animationDuration;

  const AnimatedDottedLoader({
    super.key,
    this.dotCount = 8,
    this.radius = 10,
    this.dotSize = 3,
    this.activeColor = Colors.green,
    this.inactiveColors = const [
      Color.fromARGB(255, 211, 211, 211),
      Color.fromARGB(255, 211, 211, 211),
      Color.fromARGB(255, 211, 211, 211),
      Color.fromARGB(255, 211, 211, 211),
      Color.fromARGB(255, 211, 211, 211),
      Color.fromARGB(255, 211, 211, 211),
      Color.fromARGB(255, 211, 211, 211),
      Color.fromARGB(255, 211, 211, 211),
      Color.fromARGB(255, 211, 211, 211),
    ],
    this.animationDuration = const Duration(milliseconds: 1500),
  });

  @override
  State<AnimatedDottedLoader> createState() => _AnimatedDottedLoaderState();
}

class _AnimatedDottedLoaderState extends State<AnimatedDottedLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    )..repeat();

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          width: widget.radius * 2,
          height: widget.radius * 2,
          child: CustomPaint(
            painter: DottedLoaderPainter(
              progress: _animation.value,
              dotCount: widget.dotCount,
              radius: widget.radius,
              dotSize: widget.dotSize,
              activeColor: widget.activeColor,
              inactiveColors: widget.inactiveColors,
            ),
          ),
        );
      },
    );
  }
}

class DottedLoaderPainter extends CustomPainter {
  final double progress;
  final int dotCount;
  final double radius;
  final double dotSize;
  final Color activeColor;
  final List<Color> inactiveColors;

  DottedLoaderPainter({
    required this.progress,
    required this.dotCount,
    required this.radius,
    required this.dotSize,
    required this.activeColor,
    required this.inactiveColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final angleStep = 2 * pi / dotCount;

    // Calculate which dot is active based on progress
    final activeIndex = (progress * dotCount).floor() % dotCount;

    for (int i = 0; i < dotCount; i++) {
      final angle = i * angleStep - pi / 2; // Start from top
      final dx = center.dx + radius * cos(angle);
      final dy = center.dy + radius * sin(angle);
      final dotCenter = Offset(dx, dy);

      // Determine color for this dot
      final Paint paint = Paint()..color = _getDotColor(i, activeIndex);

      canvas.drawCircle(dotCenter, dotSize / 2, paint);
    }
  }

  Color _getDotColor(int index, int activeIndex) {
    if (index == activeIndex) {
      return activeColor;
    }
    
    // Rotate colors based on active position
    final colorIndex = (index - activeIndex + dotCount) % dotCount;
    if (colorIndex < inactiveColors.length) {
      return inactiveColors[colorIndex];
    }
    return Colors.grey;
  }

  @override
  bool shouldRepaint(DottedLoaderPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.dotCount != dotCount ||
        oldDelegate.radius != radius ||
        oldDelegate.dotSize != dotSize ||
        oldDelegate.activeColor != activeColor;
  }
}