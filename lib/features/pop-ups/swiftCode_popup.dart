import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/assets.dart';

// ============================================================
// SWIFT CODE INFO POPUP (slides from top)
// ============================================================
class SwiftCodeInfoPopup extends StatefulWidget {
  const SwiftCodeInfoPopup();

  @override
  State<SwiftCodeInfoPopup> createState() => _SwiftCodeInfoPopupState();
}

class _SwiftCodeInfoPopupState extends State<SwiftCodeInfoPopup>
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
                width: 330,
                height: 450,
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
                            children: [
                              // Example Swift Code Container
                              Container(
                                width: 270,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 40,
                                  horizontal: 30,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0x4DFCFCFB), // 30% white
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // SWIFT Code Logo
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFCFCFB),
                                        borderRadius: BorderRadius.circular(35),
                                      ),
                                      alignment: Alignment.center,
                                      child: const _SwiftLogo(),
                                    ),
                                    const SizedBox(height: 4),
                                    const SizedBox(height: 10),
                                    // Example swift code label
                                    const Text(
                                      'example swift code',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                        height: 1.4,
                                        letterSpacing: 0.02,
                                        color: Color(0xFF000000),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    // Swift Code Value
                                    const Text(
                                      'UNCRITMMXX',
                                      style: TextStyle(
                                        fontFamily: 'Arial Rounded MT Bold',
                                        fontSize: 20,
                                        height: 1.5,
                                        letterSpacing: 0.02,
                                        color: Color(0xFF000000),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),
                              // Storyline Content
                              Container(
                                width: 270,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Title
                                    const Text(
                                      'What is the SWIFT Code?',
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
                                    // Description Paragraph 1
                                    const Text(
                                      'The SWIFT Code is a unique code used to identify a bank during international transfers.',
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
                                    // Description Paragraph 2
                                    const Text(
                                      'It helps money reach the correct bank worldwide.',
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

class _SwiftLogo extends StatelessWidget {
  const _SwiftLogo();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(Assets.swiftLogo, height: 22, width: 22);
  }
}
