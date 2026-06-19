import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transfa/features/pop-ups/transfaAccountFound_popup.dart';
import '../../../core/constants/assets.dart';

class CashDropPopup extends StatefulWidget {
  const CashDropPopup();

  @override
  State<CashDropPopup> createState() => CashDropPopupState();
}

class CashDropPopupState extends State<CashDropPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  bool _isCashDropActive = true;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: 350,
                  height: 666,
                  decoration: BoxDecoration(
                    color: const Color(0x1AFCFCFB),
                    borderRadius: BorderRadius.circular(56),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(56),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.02),
                            borderRadius: BorderRadius.circular(56),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 20),
                              GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: Container(
                                  width: 50,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(35),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              Expanded(
                                child: GestureDetector(
            onTap: () => {
              Navigator.of(context).pop(),
              showDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierColor: Colors.black.withOpacity(0.5),
                      builder: (context) => TransfaAccountFoundPopup(
                        userName: 'Magic Paygma',
                        userImageUrl:  Assets.magic,
                      )),
            },
            child: Column(
                                  children: [
                                    SizedBox(
                                      width: 250,
                                      height: 250,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            width: 200,
                                            height: 200,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child: ClipOval(
                                              child: Container(
                                                width: 200,
                                                height: 200,
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  image: _isCashDropActive
                                                      ? null
                                                      : const DecorationImage(
                                                          image: AssetImage(
                                                            Assets.magic,
                                                          ),
                                                          fit: BoxFit.cover,
                                                        ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 0,
                                            left: 0,
                                            right: 0,
                                            child: Center(
                                              child: SvgPicture.asset(
                                                Assets.blueBubble,
                                                width: 37,
                                                height: 37,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            left: 0,
                                            right: 0,
                                            child: Center(
                                              child: SvgPicture.asset(
                                                Assets.yellowBubble,
                                                width: 37,
                                                height: 37,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 0,
                                            top: 0,
                                            bottom: 0,
                                            child: Center(
                                              child: SvgPicture.asset(
                                                Assets.greenBubble,
                                                width: 180,
                                                height: 180,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            right: 0,
                                            top: 0,
                                            bottom: 0,
                                            child: Center(
                                              child: SvgPicture.asset(
                                                Assets.redBubble,
                                                width: 180,
                                                height: 180,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 190,
                                            height: 190,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.black.withValues(
                                                alpha: 0.05,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Material(
                                      color: Colors.transparent,
                                      child: Text(
                                        _isCashDropActive
                                            ? 'CashDrop'
                                            : 'Transfa',
                                        style: const TextStyle(
                                          fontFamily: 'Arial Rounded MT Bold',
                                          fontSize: 30,
                                          letterSpacing: 0.02,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                ),
                                child: Column(
                                  children: [
                                    Material(
                                      color: Colors.transparent,
                                      child: Text(
                                        _isCashDropActive
                                            ? 'To pay, try holding this Transfa over another Transfa.'
                                            : 'To receive, scan your face with another Transfa.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 17,
                                          height: 1.5,
                                          letterSpacing: 0.02,
                                          color: Colors.white.withValues(
                                            alpha: 0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () =>
                                              Navigator.of(context).pop(),
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [
                                                  Color(0xFFFFC30F),
                                                  Color(0xFF9747FF),
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(35),
                                            ),
                                            child: Center(
                                              child: SvgPicture.asset(
                                                Assets.home,
                                                width: 26,
                                                height: 26,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 136,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(
                                              alpha: 0.1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              35,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _isCashDropActive = false;
                                                  });
                                                },
                                                child: Container(
                                                  width: 62,
                                                  height: 42,
                                                  decoration: BoxDecoration(
                                                    gradient: !_isCashDropActive
                                                        ? const LinearGradient(
                                                            colors: [
                                                              Color(0xFF00E9F8),
                                                              Color(0xFF0D7BE1),
                                                            ],
                                                          )
                                                        : null,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          35,
                                                        ),
                                                  ),
                                                  child: Center(
                                                    child: SvgPicture.asset(
                                                      Assets.receive,
                                                      width: 20,
                                                      height: 20,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _isCashDropActive = true;
                                                  });
                                                },
                                                child: Container(
                                                  width: 62,
                                                  height: 42,
                                                  decoration: BoxDecoration(
                                                    gradient: _isCashDropActive
                                                        ? const LinearGradient(
                                                            colors: [
                                                              Color(0xFF00E9F8),
                                                              Color(0xFF0D7BE1),
                                                            ],
                                                          )
                                                        : null,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          35,
                                                        ),
                                                  ),
                                                  child: Center(
                                                    child: SvgPicture.asset(
                                                      Assets.cashDrop,
                                                      width: 24,
                                                      height: 24,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),
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
