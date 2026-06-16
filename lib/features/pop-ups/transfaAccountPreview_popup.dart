import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/assets.dart';

// ============================================================
// TRANSFA ACCOUNT PREVIEW POPUP (slides from top)
// ============================================================
class TransfaAccountPreviewPopup extends StatefulWidget {
  final String? userImageUrl;
  final String? userName;
  final VoidCallback? onTransfaCashDrop;
  final VoidCallback? onSaveToTransfa;

  const TransfaAccountPreviewPopup({
    super.key,
    this.userImageUrl,
    this.userName,
    this.onTransfaCashDrop,
    this.onSaveToTransfa,
  });

  @override
  State<TransfaAccountPreviewPopup> createState() =>
      _TransfaAccountPreviewPopupState();
}

class _TransfaAccountPreviewPopupState extends State<TransfaAccountPreviewPopup>
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
                height: 570,
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
                          padding: const EdgeInsets.all(30),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Name & Face Shot Container
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 50,
                                  horizontal: 20,
                                ),
                                child: Column(
                                  children: [
                                    // Face Shot Avatar
                                    _FaceShotAvatar(
                                      imageUrl: widget.userImageUrl,
                                    ),
                                    const SizedBox(height: 20),
                                    // User Name
                                    Text(
                                      widget.userName ?? 'Magic Payma',
                                      style: const TextStyle(
                                        fontFamily: 'Arial Rounded MT Bold',
                                        fontSize: 26,
                                        height: 1.3,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.02,
                                        color: Color(0xFF000000),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),
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
                                    // Save to Transfa Button
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        widget.onSaveToTransfa?.call();
                                      },
                                      child: Container(
                                        width: double.infinity,
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
                                            const _SaveContactIcon(),
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

class _FaceShotAvatar extends StatelessWidget {
  final String? imageUrl;

  const _FaceShotAvatar({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      height: 190,

      child: CircleAvatar(
        radius: 30,
        backgroundImage: const AssetImage(Assets.magic),
        backgroundColor: Colors.grey,
      ),
    );
  }
}

class _TransfaAirIcon extends StatelessWidget {
  const _TransfaAirIcon();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(Assets.logoSmallWhite, height: 20, width: 20);
  }
}

class _SaveContactIcon extends StatelessWidget {
  const _SaveContactIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,

      child: SvgPicture.asset(Assets.contactsDark),
    );
  }
}
