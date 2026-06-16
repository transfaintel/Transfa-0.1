import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/assets.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ============================================================
// TRANSFA STATUS UNAVAILABLE POPUP (slides from top)
// ============================================================
class TransfaStatusUnavailablePopup extends StatefulWidget {
  final VoidCallback? onClose;
  final VoidCallback? onTransfaCashDrop;
  final String accountName;
  final String accountNumber;
  final double amount;
  final String description;
  final String bankName;

  const TransfaStatusUnavailablePopup({
    super.key,
    this.onClose,
    this.onTransfaCashDrop,
    required this.accountName,
    required this.accountNumber,
    required this.amount,
    required this.description,
    required this.bankName,
  });

  @override
  State<TransfaStatusUnavailablePopup> createState() => _TransfaStatusUnavailablePopupState();
}

class _TransfaStatusUnavailablePopupState extends State<TransfaStatusUnavailablePopup>
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

  String _formatAmount(double amount) {
    return '₦${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]},')}';
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
                height: 700,
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
                          padding: const EdgeInsets.all(20),
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
                                    // Transfa small icon
                                    const _StatusTransfaIcon(),
                                    const SizedBox(width: 10),
                                    // Status Text
                                    const Expanded(
                                      child: Text(
                                        'Unavailable',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 24,
                                          height: 1.4,
                                          letterSpacing: 0.02,
                                          color: Color(0xFF000000),
                                        ),
                                      ),
                                    ),
                                    // Close Button
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        widget.onClose?.call();
                                      },
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: const Color(0x1AFCFCFB), // 10% white
                                          borderRadius: BorderRadius.circular(35),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.close,
                                            color: Color(0xFF000000),
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Face Shot, Name & Account Number
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Column(
                                  children: [
                                    // Avatar with YELLOW WAY gradient
                                    const _UnavailableBusinessAvatar(),
                                    const SizedBox(height: 10),
                                    // Business Name
                                    Text(
                                      widget.accountName,
                                      style: const TextStyle(
                                        fontFamily: 'Arial Rounded MT Bold',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 30,
                                        height: 1.25,
                                        letterSpacing: 0.02,
                                        color: Color(0xFF000000),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 10),
                                    // Account Number
                                    Text(
                                      widget.accountNumber,
                                      style: const TextStyle(
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 17,
                                        height: 1.5,
                                        letterSpacing: 0.02,
                                        color: Color(0x4D000000), // 30% opacity
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Amount & Description
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: const Color(0x80FCFCFB), // 50% white
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Column(
                                  children: [
                                    // Unable to send label
                                    const Text(
                                      'Unable to send',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 17,
                                        height: 1.5,
                                        letterSpacing: 0.02,
                                        color: Color(0x80000000), // 50% opacity
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 6),
                                    // Amount with 50% opacity
                                    Text(
                                      _formatAmount(widget.amount),
                                      style: const TextStyle(
                                        fontFamily: 'Arial Rounded MT Bold',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 30,
                                        height: 1.25,
                                        letterSpacing: 0.02,
                                        color: Color(0x80000000), // 50% opacity
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 6),
                                    // Description
                                    Text(
                                      'for “${widget.description}”.',
                                      style: const TextStyle(
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 17,
                                        height: 1.5,
                                        letterSpacing: 0.02,
                                        color: Color(0x80000000), // 50% opacity
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Status Summary with Transfa Button
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Column(
                                  children: [
                                    // Status Message
                                    Text(
                                      'The money could not be sent because “${widget.bankName}” is unavailable. Try again in a few minutes, or Transfa right now.',
                                      style: const TextStyle(
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                        height: 1.4,
                                        letterSpacing: 0.02,
                                        color: Color(0xFF000000),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 10),
                                    // Transfa (CashDrop) Button
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        widget.onTransfaCashDrop?.call();
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height: 58,
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(35),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const _UnavailableTransfaAirIcon(),
                                            const SizedBox(width: 6),
                                            const Text(
                                              'Transfa',
                                              style: TextStyle(
                                                fontFamily: 'Arial Rounded MT Bold',
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

class _UnavailableBusinessAvatar extends StatelessWidget {
  const _UnavailableBusinessAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFA800), Color(0xFFF97A21)],
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 110,
          height: 110,
          child: SvgPicture.asset(Assets.contacts),
        ),
      ),
    );
  }
}

class _StatusTransfaIcon extends StatelessWidget {
  const _StatusTransfaIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Container(
          width: 16,
          height: 20,
          child: SvgPicture.asset(Assets.logoSmallWhite),
        ),
      ),
    );
  }
}

class _UnavailableTransfaAirIcon extends StatelessWidget {
  const _UnavailableTransfaAirIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 26,
      padding: EdgeInsets.symmetric(vertical: 3),
      child: SvgPicture.asset(Assets.logoSmallWhite),
    );
  }
}