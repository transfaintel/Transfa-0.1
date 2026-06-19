import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/assets.dart';

// ============================================================
// TRANSFA STATUS POPUP WITH PROGRESS (slides from top)
// ============================================================
class TransfaStatusProgressPopup extends StatefulWidget {
  final VoidCallback? onClose;
  final String accountName;
  final String accountNumber;
  final double amount;
  final String? image;
  final String description;
  final String bankName;
  final double progressPercentage; // 0.0 to 1.0

  const TransfaStatusProgressPopup({
    super.key,
    this.onClose,
    required this.accountName,
    required this.accountNumber,
    required this.amount,
    this.image = '',
    required this.description,
    required this.bankName,
    this.progressPercentage = 0.7, // Default 70% progress
  });

  @override
  State<TransfaStatusProgressPopup> createState() =>
      _TransfaStatusProgressPopupState();
}

class _TransfaStatusProgressPopupState extends State<TransfaStatusProgressPopup>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

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

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _progressAnimation = Tween<double>(begin: 0, end: widget.progressPercentage)
        .animate(
          CurvedAnimation(
            parent: _progressController,
            curve: Curves.easeOutCubic,
          ),
        );

    _slideController.forward();
    _progressController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _progressController.dispose();
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
                height: 715,
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
                                        'Status',
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
                                          color: const Color(
                                            0x1AFCFCFB,
                                          ), // 10% white
                                          borderRadius: BorderRadius.circular(
                                            35,
                                          ),
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
                                    // Avatar with image from widget
                                    _ProgressBusinessAvatar(image: widget.image!),
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
                                        color: Color(0x80000000), // 50% opacity
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
                                    // Processing status
                                    Text(
                                      'Processing by receiver\'s bank',
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
                                    const SizedBox(height: 6),
                                    // Amount with YELLOW WAY gradient
                                    ShaderMask(
                                      shaderCallback: (bounds) {
                                        return const LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Color(0xFFFFA800),
                                            Color(0xFFF97A21),
                                          ],
                                        ).createShader(bounds);
                                      },
                                      child: Text(
                                        _formatAmount(widget.amount),
                                        style: const TextStyle(
                                          fontFamily: 'Arial Rounded MT Bold',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 30,
                                          height: 1.25,
                                          letterSpacing: 0.02,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
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
                              // Status Summary with Progress Bar
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Column(
                                  children: [
                                    // Payment Processing Row
                                    Container(
                                      width: double.infinity,
                                      height: 50,
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          // Expiry Icon
                                          Container(
                                            width: 30,
                                            height: 30,
                                            child: SvgPicture.asset(
                                              Assets.timeGold,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          // Time Bar
                                          Expanded(
                                            child: Container(
                                              height: 6,
                                              decoration: BoxDecoration(
                                                color: const Color(
                                                  0x08000000,
                                                ), // 3% opacity
                                                borderRadius:
                                                    BorderRadius.circular(35),
                                              ),
                                              child: AnimatedBuilder(
                                                animation: _progressAnimation,
                                                builder: (context, child) {
                                                  return FractionallySizedBox(
                                                    widthFactor:
                                                        _progressAnimation
                                                            .value,
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                            const LinearGradient(
                                                              begin: Alignment
                                                                  .topCenter,
                                                              end: Alignment
                                                                  .bottomCenter,
                                                              colors: [
                                                                Color(
                                                                  0xFFFFA800,
                                                                ),
                                                                Color(
                                                                  0xFFF97A21,
                                                                ),
                                                              ],
                                                            ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              35,
                                                            ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    // Status Message
                                    Text(
                                      'The money has been sent and is being processed by “${widget.bankName}”. Payments arrive within minutes. Transfa Accounts receive money instantly.',
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
class _ProgressBusinessAvatar extends StatelessWidget {
  final String image;
  
  const _ProgressBusinessAvatar({required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      child: Center(
        child: Container(
          width: 110,
          height: 110,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFF6777), Color(0xFFF74155)],
            ),
            shape: BoxShape.circle,
          ),
          clipBehavior: Clip.hardEdge,
          child: image.isEmpty
              ? SvgPicture.asset(
                  Assets.contacts,
                  width: 110,
                  height: 110,
                  fit: BoxFit.contain,
                )
              : Image.asset(
                  image,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}