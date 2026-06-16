import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/assets.dart';

// ============================================================
// ENTER CORRECT CODE POPUP (slides from top)
// ============================================================
class EnterCorrectCodePopup extends StatefulWidget {
  final VoidCallback? onClose;

  const EnterCorrectCodePopup({super.key, this.onClose});

  @override
  State<EnterCorrectCodePopup> createState() => _EnterCorrectCodePopupState();
}

class _EnterCorrectCodePopupState extends State<EnterCorrectCodePopup>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
    _slideController.forward();

    // Auto close after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pop();
        widget.onClose?.call();
      }
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        widget.onClose?.call();
      },
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: 172,
                height: 82,
                
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SvgPicture.asset(Assets.enterCorrectCode),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
