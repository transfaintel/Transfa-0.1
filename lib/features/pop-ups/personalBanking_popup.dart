import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/assets.dart';

// ============================================================
// BANKING POPUP (slides from top)
// ============================================================
class PersonalBankingPopup extends StatefulWidget {
  final VoidCallback? onSaveToTransfa;
  final VoidCallback? onTransfaCashDrop;

  const PersonalBankingPopup({
    super.key,
    this.onSaveToTransfa,
    this.onTransfaCashDrop,
  });

  @override
  State<PersonalBankingPopup> createState() => _BankingPopupState();
}

class _BankingPopupState extends State<PersonalBankingPopup>
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
                width: 366,
                height: 645,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(56),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(56),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0x80FCFCFB), // 50% white
                          borderRadius: BorderRadius.circular(56),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Name & Dummy Shot Container
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 50,
                                  horizontal: 20,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(35),
                                ),
                                child: Column(
                                  children: [
                                    // Avatar with gradient
                                    const _BankingAvatar(),
                                    const SizedBox(height: 20),
                                    // Name
                                    const Text(
                                      'Barry Bontulipo',
                                      style: TextStyle(
                                        fontFamily: 'Arial Rounded MT Bold',
                                        fontSize: 26,
                                        height: 1.3,
                                        letterSpacing: 0.02,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF000000),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Account Number & Bank Container
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(0x80FCFCFB), // 50% white
                                  borderRadius: BorderRadius.circular(35),
                                ),
                                child: Column(
                                  children: [
                                    // Account Number Row
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(14),
                                      child: Row(
                                        children: [
                                          // Bank Icon Container
                                          Container(
                                            width: 50,
                                            height: 50,
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Color(0xFFFCFCFB),
                                                  Color(0xB3FCFCFB),
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(35),
                                            ),
                                            child: const _BankIcon(),
                                          ),
                                          const SizedBox(width: 14),
                                          // Account Details
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Account',
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16,
                                                    height: 1.4,
                                                    letterSpacing: 0.02,
                                                    color: Color(
                                                      0x4D000000,
                                                    ), // 30% opacity
                                                  ),
                                                ),
                                                const Text(
                                                  '207 922 3313',
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
                                        ],
                                      ),
                                    ),
                                    // Slim Divider
                                    Container(
                                      width: 286,
                                      height: 1,
                                      color: const Color(
                                        0x08000000,
                                      ), // 3% opacity
                                    ),
                                    // Bank Row
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(14),
                                      child: Row(
                                        children: [
                                          // Bank Logo Container
                                          Container(
                                            width: 50,
                                            height: 50,
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(35),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withValues(alpha: 0.07),
                                                  blurRadius: 7,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: Image.asset(
                                                Assets.bankOpay,
                                                height: 40,
                                                width: 40,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 14),
                                          Expanded(
                                            child: Text(
                                              'OPay',
                                              style: const TextStyle(
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.w400,
                                                fontSize: 17,
                                                height: 1.5,
                                                letterSpacing: 0.02,
                                                color: Color(0xFF000000),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Banking Profile Options
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    // Save to Transfa Button (Bright)
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          widget.onSaveToTransfa?.call();
                                        },
                                        child: Container(
                                          height: 58,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFCFCFB),
                                            borderRadius: BorderRadius.circular(
                                              35,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const _ContactIcon(),
                                              const SizedBox(width: 6),
                                              const Text(
                                                'Save',
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
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    // Transfa (CashDrop) Button
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          widget.onTransfaCashDrop?.call();
                                        },
                                        child: Container(
                                          height: 58,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.circular(
                                              35,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const _TransfaAirIcon(),
                                              const SizedBox(width: 6),
                                              const Text(
                                                'Transfa',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 17,
                                                  height: 1.5,
                                                  letterSpacing: 0.02,
                                                  color: Color(0xFFFCFCFB),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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

class _BankingAvatar extends StatelessWidget {
  const _BankingAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF00FD83), Color(0xFF00A95D)],
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 150,
          height: 150,
          child: SvgPicture.asset(Assets.contacts),
        ),
      ),
    );
  }
}

class _BankIcon extends StatelessWidget {
  const _BankIcon();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(Assets.bankBlack, height: 26, width: 26);
  }
}

class _ContactIcon extends StatelessWidget {
  const _ContactIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      child: SvgPicture.asset(Assets.contactsDark, height: 20, width: 20),
    );
  }
}

class _TransfaAirIcon extends StatelessWidget {
  const _TransfaAirIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 30,
      child: SvgPicture.asset(Assets.logoSmallWhite, height: 20, width: 20),
    );
  }
}
