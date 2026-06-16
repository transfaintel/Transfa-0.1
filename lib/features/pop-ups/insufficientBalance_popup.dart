import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/assets.dart';
import '../../shared/widgets/transfa_logo.dart';

// ============================================================
// INSUFFICIENT MONEY POPUP (slides from top)
// ============================================================
class InsufficientMoneyPopup extends StatefulWidget {
  final VoidCallback? onAddMoney;

  const InsufficientMoneyPopup({super.key, this.onAddMoney});

  @override
  State<InsufficientMoneyPopup> createState() => _InsufficientMoneyPopupState();
}

class _InsufficientMoneyPopupState extends State<InsufficientMoneyPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Center(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: 270,
                height: 290,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(45),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(45),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0x80FCFCFB), // 50% white
                          borderRadius: BorderRadius.circular(45),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Header Card
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Network Unavailable Icon (Warning/Error Icon)
                                    const _WarningIcon(),
                                    const SizedBox(height: 18),
                                    // Title
                                    const Text(
                                      'Insufficient Money',
                                      style: TextStyle(
                                        fontFamily: 'Arial Rounded MT Bold',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        height: 1.5,
                                        letterSpacing: 0.02,
                                        color: Color(0xFF000000),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    // Description
                                    const Text(
                                      'To pay instantly, add money to your Transfa.',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 17,
                                        height: 1.5,
                                        letterSpacing: 0.02,
                                        color: Color(0xFF000000),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              // Transfa Option Card
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  widget.onAddMoney?.call();
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 60,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0x1AFCFCFB), // 10% white
                                    borderRadius: BorderRadius.circular(35),
                                  ),
                                  child: Row(
                                    children: [
                                      // Transfa Logo Container
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(
                                            35,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: const _TransfaSmallLogo(),
                                      ),
                                      const SizedBox(width: 10),
                                      // Transfa Label
                                      const Expanded(
                                        child: Text(
                                          'Transfa',
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w400,
                                            fontSize: 17,
                                            height: 1.5,
                                            letterSpacing: 0.02,
                                            color: Color(0xFF000000),
                                          ),
                                        ),
                                      ),
                                      // Add Button
                                      Container(
                                        width: 66,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Color(0xFFFF7088),
                                              Color(0xFFF41E42),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            35,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'Add',
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                            height: 1.5,
                                            letterSpacing: 0.02,
                                            color: Color(0xFFFCFCFB),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WarningIcon extends StatelessWidget {
  const _WarningIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      
      child: SvgPicture.asset(Assets.networkUnavailable),
    );
  }
}

class _TransfaSmallLogo extends StatelessWidget {
  const _TransfaSmallLogo();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(Assets.logoSmallWhite, height: 20, width: 20,);
  }
}
