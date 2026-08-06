import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:transfa/features/pop-ups/transfaAccountFound_popup.dart';
import 'package:transfa/shared/widgets/homeFab.dart';
import '../../../core/constants/assets.dart';

class CashDropPopup extends StatefulWidget {
  const CashDropPopup({super.key});

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

  void _closePopup() => Navigator.of(context).pop();

  void _showTransfaAccountFound() {
    _closePopup();
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => const TransfaAccountFoundPopup(
        userName: 'Magic Paygma',
        userImageUrl: Assets.coperateMan,
      ),
    );
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
                              _buildDragHandle(),
                              const SizedBox(height: 30),
                              _buildMainContent(),
                              _buildBottomActions(),
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

  Widget _buildDragHandle() {
    return GestureDetector(
      onTap: _closePopup,
      child: Container(
        width: 50,
        height: 10,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(35),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Expanded(
      child: GestureDetector(
        onTap: _showTransfaAccountFound,
        child: Column(
          children: [
            _buildAvatarStack(),
            const SizedBox(height: 20),
            _buildTitle(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarStack() {
    return SizedBox(
      width: 250,
      height: 250,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Base circle with optional image
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: _isCashDropActive
                  ? null
                  : const DecorationImage(
                      image: AssetImage(Assets.coperateMan),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          // Blue bubble (top)
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
          // Yellow bubble (bottom)
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
          // Green bubble (left)
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
          // Red bubble (right)
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
          // Overlay circle
          Container(
            width: 190,
            height: 190,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withValues(alpha: 0.05),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Material(
      color: Colors.transparent,
      child: Text(
        _isCashDropActive ? 'CashDrop' : 'Transfa',
        style: const TextStyle(
          fontFamily: 'Arial Rounded MT Bold',
          fontSize: 30,
          letterSpacing: 0.02,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          _buildDescription(),
          const SizedBox(height: 20),
          _buildActionRow(),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Material(
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
          color: Colors.white.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  Widget _buildActionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Home Button - maintaining original size
        HomeFab(size: 50, onTap: _closePopup),

        // Toggle Buttons Container - with equal padding
        Container(
          width: 136,
          height: 50,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(35),
          ),
          child: Row(
            children: [
              // Receive Button
              _buildToggleButton(
                isActive: !_isCashDropActive,
                onTap: () => setState(() => _isCashDropActive = false),
                icon: Assets.recieveWhite,
                iconWidth: 20,
                iconHeight: 20,
              ),
              // CashDrop Button
              _buildToggleButton(
                isActive: _isCashDropActive,
                onTap: () => setState(() => _isCashDropActive = true),
                icon: Assets.cashDrop,
                iconWidth: 24,
                iconHeight: 24,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToggleButton({
    required bool isActive,
    required VoidCallback onTap,
    required String icon,
    required double iconWidth,
    required double iconHeight,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 62,
        height: 42,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          gradient: isActive
              ? const LinearGradient(
                  colors: [Color(0xFF00E9F8), Color(0xFF0D7BE1)],
                )
              : null,
          borderRadius: BorderRadius.circular(35),
        ),
        child: Center(
          child: SvgPicture.asset(
            icon,
            width: iconWidth,
            height: iconHeight,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
