import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/assets.dart';

class ChooseBankPopup extends StatefulWidget {
  final VoidCallback? onTransfaSelected;
  final VoidCallback? onChaseSelected;
  final VoidCallback? onOPaySelected;

  const ChooseBankPopup({
    super.key,
    this.onTransfaSelected,
    this.onChaseSelected,
    this.onOPaySelected,
  });

  @override
  State<ChooseBankPopup> createState() => _ChooseBankPopupState();
}

class _ChooseBankPopupState extends State<ChooseBankPopup>
    with SingleTickerProviderStateMixin {
  late final AnimationController _slideController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
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
                width: 270,
                height: 446,
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
                          color: const Color(0x80FCFCFB),
                          borderRadius: BorderRadius.circular(45),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildHeader(),
                              const SizedBox(height: 12),
                              _buildBankOption(
                                icon: const _TransfaSmallIcon(),
                                label: 'Transfa',
                                onTap: widget.onTransfaSelected,
                              ),
                              const SizedBox(height: 12),
                              _buildBankOption(
                                icon: const _ChaseIcon(),
                                label: 'Chase',
                                onTap: widget.onChaseSelected,
                              ),
                              const SizedBox(height: 12),
                              _buildBankOption(
                                icon: const _OPayIcon(),
                                label: 'OPay',
                                onTap: widget.onOPaySelected,
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

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: _HeaderTransfaIcon(),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose a Bank',
                  style: TextStyle(
                    fontFamily: 'Arial Rounded MT Bold',
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    height: 1.5,
                    letterSpacing: 0.02,
                    color: Color(0xFF000000),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Magic has multiple bank accounts, choose a bank to pay.',
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
    );
  }

  Widget _buildBankOption({
    required Widget icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        onTap?.call();
      },
      child: Container(
        width: double.infinity,
        height: 60,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(35),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.25),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.2),
              Colors.white.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
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
    );
  }
}

class _HeaderTransfaIcon extends StatelessWidget {
  const _HeaderTransfaIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SvgPicture.asset(Assets.logoSmallWhite, height: 40, width: 40),
    );
  }
}

class _TransfaSmallIcon extends StatelessWidget {
  const _TransfaSmallIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(35),
      ),
      child: Center(
        child: SizedBox(
          width: 16,
          height: 20,
          child: SvgPicture.asset(Assets.logoSmallWhite, height: 40, width: 40),
        ),
      ),
    );
  }
}

class _ChaseIcon extends StatelessWidget {
  const _ChaseIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3F5),
        borderRadius: BorderRadius.circular(35),
      ),
      child: SvgPicture.asset(Assets.bankchase),
    );
  }
}

class _OPayIcon extends StatelessWidget {
  const _OPayIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
      ),
      child: Image.asset(Assets.bankOpay),
    );
  }
}
