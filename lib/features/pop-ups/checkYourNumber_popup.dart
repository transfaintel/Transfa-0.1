import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/assets.dart';

// ============================================================
// CHECK YOUR NUMBER POPUP (fade in/out)
// ============================================================
class CheckYourNumberPopup extends StatefulWidget {
  final VoidCallback? onClose;

  const CheckYourNumberPopup({super.key, this.onClose});

  @override
  State<CheckYourNumberPopup> createState() => _CheckYourNumberPopupState();
}

class _CheckYourNumberPopupState extends State<CheckYourNumberPopup>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Fade in animation
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _fadeController.forward();

    // Auto close after 1 seconds with fade out
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        _fadeController.reverse().then((_) {
          if (mounted) {
            Navigator.of(context).pop();
            widget.onClose?.call();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _fadeController.reverse().then((_) {
          if (mounted) {
            Navigator.of(context).pop();
            widget.onClose?.call();
          }
        });
      },
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 30, 110),
          child: Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {}, // Prevent tap from closing when clicking on popup
              child: Container(
                width: 172,
                height: 82,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SvgPicture.asset(Assets.checkYourNumber),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
