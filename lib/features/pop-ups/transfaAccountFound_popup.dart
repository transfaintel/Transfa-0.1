import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/assets.dart';
import '../../core/router/routes.dart';

// ============================================================
// TRANSFA ACCOUNT FOUND POPUP
// ============================================================

class TransfaAccountFoundPopup extends StatefulWidget {
  final String userName;
  final String userImageUrl;
  final VoidCallback? onSaveToTransfa;
  final VoidCallback? onTransfaCashDrop;

  const TransfaAccountFoundPopup({
    super.key,
    required this.userName,
    this.userImageUrl = Assets.magic,
    this.onSaveToTransfa,
    this.onTransfaCashDrop,
  });

  @override
  State<TransfaAccountFoundPopup> createState() =>
      _TransfaAccountFoundPopupState();
}

class _TransfaAccountFoundPopupState extends State<TransfaAccountFoundPopup>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _closePopup() => Navigator.of(context).pop();

  void _navigateToAmount() {
    _closePopup();
    context.push(Routes.amount);
  }

  void _handleSaveToTransfa() {
    _closePopup();
    widget.onSaveToTransfa?.call();
  }

  void _handleTransfaCashDrop() {
    _closePopup();
    widget.onTransfaCashDrop?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _closePopup,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Center(
            child: GestureDetector(
              onTap: () {}, // Prevents closing when tapping inside
              child: Container(
                width: 366,
                height: 625,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(56),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
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
                          color: const Color(0x1AFCFCFB),
                          borderRadius: BorderRadius.circular(56),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildHeader(),
                            const SizedBox(height: 58),
                            _buildUserProfile(),
                            const SizedBox(height: 57),
                            _buildActionButtons(),
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
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 60,
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          const _CashDropIcon(),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'CashDrop',
              style: TextStyle(
                fontFamily: 'Arial Rounded MT Bold',
                fontWeight: FontWeight.w600,
                fontSize: 26,
                color: Color(0xFFFCFCFB),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfile() {
    return Column(
      children: [
        Container(
          width: 190,
          height: 190,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(190),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.09), blurRadius: 9),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(190),
            child: widget.userImageUrl.isNotEmpty
                ? Image.asset(widget.userImageUrl, fit: BoxFit.cover)
                : const Icon(Icons.person, size: 80, color: Colors.white70),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          widget.userName,
          style: const TextStyle(
            fontFamily: 'Arial Rounded MT Bold',
            fontWeight: FontWeight.w600,
            fontSize: 26,
            color: Color(0xFFFCFCFB),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        _buildTransfaButton(),
        const SizedBox(height: 20),
        _buildSaveButton(),
      ],
    );
  }

  Widget _buildTransfaButton() {
    return GestureDetector(
      onTap: _navigateToAmount,
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
            const _TransfaIcon(),
            const SizedBox(width: 6),
            const Text(
              'Transfa',
              style: TextStyle(
                fontFamily: 'Arial Rounded MT Bold',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Color(0xFFFCFCFB),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: _handleSaveToTransfa,
      child: Container(
        width: double.infinity,
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0x1AFCFCFB),
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _SaveIcon(),
            const SizedBox(width: 6),
            const Text(
              'Save',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 17,
                color: Color(0xFFFCFCFB),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// REUSABLE ICON WIDGETS
// ============================================================

class _CashDropIcon extends StatelessWidget {
  const _CashDropIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF00E9F8), Color(0xFF0D7BE1)],
        ),
      ),
      child: Center(
        child: SvgPicture.asset(Assets.cashDrop, width: 26, height: 26.67),
      ),
    );
  }
}

class _TransfaIcon extends StatelessWidget {
  const _TransfaIcon();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(Assets.logoSmallWhite, width: 20, height: 26);
  }
}

class _SaveIcon extends StatelessWidget {
  const _SaveIcon();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(Assets.contactsWhite, width: 22, height: 22);
  }
}
