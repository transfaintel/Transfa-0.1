import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/assets.dart';
import '../../../shared/widgets/transfa_logo.dart';

// ============================================================
// MULTIPLE BANKS POPUP
// ============================================================

class MultipleBanksPopup extends StatefulWidget {
  const MultipleBanksPopup({super.key});

  @override
  State<MultipleBanksPopup> createState() => _MultipleBanksPopupState();
}

class _MultipleBanksPopupState extends State<MultipleBanksPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  // final String? accountNumber = '207 922 3313';
  final String? accountNumber = null;

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
              child: Container(
                width: 378,
                height: 560,
                decoration: BoxDecoration(
                  color: const Color(0xFFFCFCFB).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(45),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(45),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Material(
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          // Header
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  alignment: Alignment.center,
                                  child: const TransfaMark(
                                    size: 16,
                                    white: true,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Expanded(
                                  child: Text(
                                    'Transfa',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 24,
                                      letterSpacing: 0.02,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.of(context).pop(),
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFFFCFCFB,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(35),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.close_rounded,
                                      size: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Scrollable content
                          Expanded(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  // Face Shot, Name & Account Number
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 120,
                                          height: 120,

                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              120,
                                            ),
                                            child: Image.asset(
                                              Assets.magic,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        const Text(
                                          'Magic Payma',
                                          style: TextStyle(
                                            fontFamily: 'Arial Rounded MT Bold',
                                            fontSize: 30,
                                            letterSpacing: 0.02,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        accountNumber != null
                                            ? Text(
                                                accountNumber!,
                                                style: const TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 17,
                                                  letterSpacing: 0.02,
                                                  color: Colors.black54,
                                                ),
                                              )
                                            : const SizedBox(height: 0),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  // Choose a Bank section
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFCFCFB),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Column(
                                      children: [
                                        // Navigation Note
                                        accountNumber != null
                                            ? Container(
                                                width: double.infinity,
                                                padding: const EdgeInsets.all(
                                                  16,
                                                ),
                                                child: const Text(
                                                  'This account number is connected to multiple banks, choose a bank to pay.',
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16,
                                                    letterSpacing: 0.02,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                width: double.infinity,
                                                padding: const EdgeInsets.all(
                                                  16,
                                                ),
                                                child: const Text(
                                                  'Magic has multiple bank accounts, choose a bank to pay.',
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16,
                                                    letterSpacing: 0.02,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                        const SizedBox(height: 10),

                                        // Bank 1 - Transfa
                                        _BankOption(
                                          logo: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(35),
                                            ),
                                            alignment: Alignment.center,
                                            child: const TransfaMark(
                                              size: 24,
                                              white: true,
                                            ),
                                          ),
                                          name: 'Transfa',
                                          onTap: () {
                                            // Handle bank selection
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        const Divider(
                                          height: 1,
                                          color: Color(0xFFF0F0F0),
                                        ),

                                        // Bank 2 - FCMB
                                        _BankOption(
                                          logo: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF5C2684),
                                              borderRadius:
                                                  BorderRadius.circular(35),
                                            ),
                                            alignment: Alignment.center,
                                            child: Image.asset(
                                              Assets.bankFcmb,
                                              width: 30,
                                              height: 30,
                                            ),
                                          ),
                                          name: 'FCMB',
                                          onTap: () {
                                            // Handle bank selection
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        const Divider(
                                          height: 1,
                                          color: Color(0xFFF0F0F0),
                                        ),

                                        // Bank 3 - OPay
                                        _BankOption(
                                          logo: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFFFFFF),
                                              borderRadius:
                                                  BorderRadius.circular(35),
                                            ),
                                            alignment: Alignment.center,
                                            child: Image.asset(
                                              Assets.bankOpay,
                                              width: 30,
                                              height: 30,
                                            ),
                                          ),
                                          name: 'OPay',
                                          onTap: () {
                                            // Handle bank selection
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 20),
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
    );
  }
}

class _BankOption extends StatelessWidget {
  final Widget logo;
  final String name;
  final VoidCallback onTap;

  const _BankOption({
    required this.logo,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        child: Row(
          children: [
            logo,
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 17,
                  letterSpacing: 0.02,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              width: 16,
              height: 16,
              alignment: Alignment.center,
              child: SvgPicture.asset(Assets.forward, width: 10, height: 6),
            ),
          ],
        ),
      ),
    );
  }
}
