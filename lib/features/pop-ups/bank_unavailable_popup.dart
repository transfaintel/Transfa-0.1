// lib/features/pop-ups/bank_unavailable_popup.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/assets.dart';

/// Bank Unavailable Popup with slide animations
class BankUnavailablePopup extends StatefulWidget {
  final String bankName;
  final VoidCallback? onContinueWithTransfa;
  final VoidCallback? onClose;

  const BankUnavailablePopup({
    super.key,
    required this.bankName,
    this.onContinueWithTransfa,
    this.onClose,
  });

  @override
  State<BankUnavailablePopup> createState() => _BankUnavailablePopupState();
}

class _BankUnavailablePopupState extends State<BankUnavailablePopup>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> closeWithAnimation() async {
    await _animationController.reverse();
    if (mounted) {
      widget.onClose?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          await closeWithAnimation();
        }
      },
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: GestureDetector(
            onTap: () {},
            child: SlideTransition(
              position: _slideAnimation,
              child: _BankUnavailableContent(
                bankName: widget.bankName,
                onContinue: () {
                  widget.onContinueWithTransfa?.call();
                  closeWithAnimation();
                },
                onClose: closeWithAnimation,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BankUnavailableContent extends StatelessWidget {
  final String bankName;
  final VoidCallback onContinue;
  final VoidCallback onClose;

  const _BankUnavailableContent({
    required this.bankName,
    required this.onContinue,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 270,
      height: 440,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFCFB).withOpacity(0.5),
        borderRadius: BorderRadius.circular(45),
      ),
      child: Column(
        children: [
          // Notification Story Card
          Container(
            width: 246,
            height: 250,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              children: [
                // Network Unavailable Icon
                // Network Unavailable Icon
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                  width: 60,
                  height: 60,
                  child: SvgPicture.asset(Assets.networkUnavailable),
                )),
                const SizedBox(height: 12),
                // Storyline Text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bank Unavailable',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        height: 1.5,
                        letterSpacing: 0.02,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'The money could not be sent because "$bankName" is unavailable.',
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        fontSize: 17,
                        height: 1.5,
                        letterSpacing: 0.02,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Continue with Transfa?',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                        height: 1.5,
                        letterSpacing: 0.02,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Options Card
          Container(
            width: 246,
            height: 153,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              children: [
                // Transfa Option Button
                GestureDetector(
                  onTap: onContinue,
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCFCFB).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10,),
                      child: Row(
                        children: [
                          // Transfa small icon
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(35),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                Assets.transfaLife,
                                width: 16,
                                height: 20,
                                fit: BoxFit.contain,
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Transfa',
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                height: 1.4,
                                letterSpacing: 0.02,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35),
                            ),
                            child: Container(
                              width: 16,
                              height: 16,
                              child: SvgPicture.asset(Assets.checkGreen),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Continue Button
                GestureDetector(
                  onTap: onContinue,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFFF4466), Color(0xFFF41E42)],
                      ),
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: const Center(
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                          height: 1.5,
                          letterSpacing: 0.02,
                          color: Color(0xFFFCFCFB),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper method to show the bank unavailable popup
Future<void> showBankUnavailablePopup(
  BuildContext context, {
  required String bankName,
  VoidCallback? onContinueWithTransfa,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.7),
    useRootNavigator: true,
    builder: (dialogContext) => BankUnavailablePopup(
      bankName: bankName,
      onContinueWithTransfa: onContinueWithTransfa,
      onClose: () => Navigator.of(dialogContext).pop(),
    ),
  );
}