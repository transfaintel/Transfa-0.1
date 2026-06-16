import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/assets.dart';

// ============================================================
// TRANSFA ACCOUNT FOUND POPUP (slides from top)
// ============================================================
class TransfaAccountFoundPopup extends StatefulWidget {
  final VoidCallback? onTransfaCashDrop;
  final VoidCallback? onSaveToTransfa;
  final String userName;
  final String userImageUrl;

  const TransfaAccountFoundPopup({
    super.key,
    this.onTransfaCashDrop,
    this.onSaveToTransfa,
    required this.userName,
    this.userImageUrl = '',
  });

  @override
  State<TransfaAccountFoundPopup> createState() =>
      _TransfaAccountFoundPopupState();
}

class _TransfaAccountFoundPopupState extends State<TransfaAccountFoundPopup>
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
                width: 366,
                height: 620,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(56),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 0),
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
                          color: const Color(0x1AFCFCFB), // 10% white
                          borderRadius: BorderRadius.circular(56),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 5,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Send Navigation
                              Container(
                                width: double.infinity,
                                height: 60,
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    // CashDrop Home Icon
                                    const _AccountFoundCashDropIcon(),
                                    const SizedBox(width: 10),
                                    // CashDrop Text
                                    const Expanded(
                                      child: Text(
                                        'CashDrop',
                                        style: TextStyle(
                                          fontFamily: 'Arial Rounded MT Bold',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 26,
                                          height: 1.3,
                                          letterSpacing: 0.02,
                                          color: Color(0xFFFCFCFB),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 58),
                              // Name & Face Shot
                              Container(
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    // Face Shot Container
                                    Container(
                                      width: 190,
                                      height: 190,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(35),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.09,
                                            ),
                                            blurRadius: 9,
                                            offset: const Offset(0, 0),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(190),
                                        child: Container(
                                        
                                          child: widget.userImageUrl.isNotEmpty
                                              ? Image.asset(
                                                  widget.userImageUrl,
                                                  fit: BoxFit.cover,
                                                )
                                              : const Icon(
                                                  Icons.person,
                                                  size: 80,
                                                  color: Colors.white70,
                                                ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    // User Name
                                    Text(
                                      widget.userName,
                                      style: const TextStyle(
                                        fontFamily: 'Arial Rounded MT Bold',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 26,
                                        height: 1.3,
                                        letterSpacing: 0.02,
                                        color: Color(0xFFFCFCFB),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 58),
                              // Transfa Account Preview Options
                              Container(
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    // Transfa (CashDrop) Button
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        widget.onTransfaCashDrop?.call();
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height: 58,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 16,
                                        ),
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
                                            const _AccountFoundTransfaAirIcon(),
                                            const SizedBox(width: 6),
                                            const Text(
                                              'Transfa',
                                              style: TextStyle(
                                                fontFamily:
                                                    'Arial Rounded MT Bold',
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16,
                                                height: 1.2,
                                                letterSpacing: 0.02,
                                                color: Color(0xFFFCFCFB),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    // Save to Transfa (Dark) Button
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        widget.onSaveToTransfa?.call();
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height: 58,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 16,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0x1AFCFCFB,
                                          ), // 10% white
                                          borderRadius: BorderRadius.circular(
                                            35,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.05,
                                              ),
                                              blurRadius: 5,
                                              offset: const Offset(0, 0),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const _AccountFoundSaveIcon(),
                                            const SizedBox(width: 6),
                                            const Text(
                                              'Save',
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.w400,
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

class _AccountFoundCashDropIcon extends StatelessWidget {
  const _AccountFoundCashDropIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      child: Stack(
        children: [
          // Cover with gradient
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF00E9F8), Color(0xFF0D7BE1)],
              ),
            ),
          ),
          // CashDrop icon
          Center(
            child: Container(
              width: 26,
              height: 26.67,
              
              child: SvgPicture.asset(Assets.cashDrop),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountFoundTransfaAirIcon extends StatelessWidget {
  const _AccountFoundTransfaAirIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 26,
      child: SvgPicture.asset(Assets.logoSmallWhite),
    );
  }
}

class _AccountFoundSaveIcon extends StatelessWidget {
  const _AccountFoundSaveIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      child: SvgPicture.asset(Assets.contactsWhite),
    );
  }
}
