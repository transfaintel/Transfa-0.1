import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../core/constants/assets.dart';

// ============================================================
// TRANSFA & ID PRIVACY POPUP (slides from top)
// ============================================================
class TransfaIDPrivacyPopup extends StatefulWidget {
  final VoidCallback? onClose;
  final VoidCallback? onAgree;

  const TransfaIDPrivacyPopup({
    super.key,
    this.onClose,
    this.onAgree,
  });

  @override
  State<TransfaIDPrivacyPopup> createState() => _TransfaIDPrivacyPopupState();
}

class _TransfaIDPrivacyPopupState extends State<TransfaIDPrivacyPopup>
    with TickerProviderStateMixin {
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
                width: 330,
                height: 428,
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
                          padding: const EdgeInsets.all(30),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Transfa & You Icon
                              const _PrivacyTransfaIcon(),
                              const SizedBox(height: 20),
                              // Storyline Content
                              Container(
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Title
                                    const Text(
                                      'Transfa & Bank Privacy...',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20,
                                        height: 1.5,
                                        letterSpacing: 0.02,
                                        color: Color(0xFF000000),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    // Privacy Description
                                    const Text(
                                      'Identity-related information, National Identity Number (NIN), location, and use patterns may be used to provide assessment to your bank to set up Transfa and prevent identity fraud.',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 17,
                                        height: 1.5,
                                        letterSpacing: 0.02,
                                        color: Color(0xFF000000),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    // Privacy statement 1
                                    const Text(
                                      'At Transfa, privacy is design.',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 17,
                                        height: 1.5,
                                        letterSpacing: 0.02,
                                        color: Color(0xFF000000),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    // Privacy statement 2
                                    const Text(
                                      'Transfa does not sell info.',
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
                              // Action Buttons
                              
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

class _PrivacyTransfaIcon extends StatelessWidget {
  const _PrivacyTransfaIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      padding: EdgeInsets.all(5),
        child: SvgPicture.asset(Assets.transfaYou, height: 34, width: 40,)
     
    );
  }
}