import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:transfa/shared/widgets/animated_dotted_loader.dart';

import '../../../core/theme/app_colors.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/assets.dart';
import '../../../shared/widgets/pill_button.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/keypad_button.dart';
import '../../../shared/widgets/wallpaper_scaffold.dart';
import '../../../shared/widgets/transfa_logo.dart';

/// Shared lockscreen scaffold for the passcode unlock surfaces. The
/// content above the keypad and the bottom action row are customisable.
class _LockscreenShell extends StatelessWidget {
  final Widget header;
  final int length;
  final int filled;
  final ValueChanged<String> onKey;
  final VoidCallback onBack;
  final Widget? leftButton;
  final Widget? rightButton;

  const _LockscreenShell({
    required this.header,
    required this.length,
    required this.filled,
    required this.onKey,
    required this.onBack,
    this.leftButton,
    this.rightButton,
  });

  @override
  Widget build(BuildContext context) {
    return WallpaperScaffold(
      darken: 0.55,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 80, 20, 24),
        child: Column(
          children: [
            header,
            const SizedBox(height: 26),
            _Dots(length: length, filled: filled),

            const SizedBox(height: 22),
            _Keypad(onTap: onKey, onBack: onBack, showBack: filled > 0),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: leftButton ?? const SizedBox()),
                const SizedBox(width: 12),
                Flexible(child: rightButton ?? const SizedBox()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  final int length;
  final int filled;
  const _Dots({required this.length, required this.filled});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (i) {
        final isFilled = i < filled;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(horizontal: 12),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: isFilled ? Colors.white : Colors.transparent,
            border: Border.all(color: Colors.white, width: 1.4),
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}

class _Keypad extends StatelessWidget {
  final ValueChanged<String> onTap;
  final VoidCallback onBack;
  final bool showBack;
  const _Keypad({
    required this.onTap,
    required this.onBack,
    required this.showBack,
  });

  Widget _row(List<String> keys) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: keys
          .map((k) => KeypadButton(digit: k, onTap: () => onTap(k)))
          .toList(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _row(['1', '2', '3']),
        _row(['4', '5', '6']),
        _row(['7', '8', '9']),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(width: 78),
              KeypadButton(digit: '0', onTap: () => onTap('0')),
              SizedBox(
                width: 78,
                child: showBack
                    ? IconButton(
                        onPressed: onBack,
                        icon: const Icon(
                          Icons.backspace_outlined,
                          color: Colors.white,
                          size: 26,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PillTextButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _PillTextButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        width: 500,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withValues(alpha: 0.30)),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTypography.body.copyWith(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}

/// Red-gradient Cancel pill used on the Pay-with-Passcode screen.
class _RedCancelPill extends StatelessWidget {
  final VoidCallback onTap;
  const _RedCancelPill({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        width: 130,
        padding: const EdgeInsets.symmetric(horizontal: 36),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primaryLight, AppColors.primary],
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.30),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          'Cancel',
          style: AppTypography.body.copyWith(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

/// "Unlock with Your Transfa Passcode" — main unlock lockscreen.
class UnlockPasscodeScreen extends StatefulWidget {
  const UnlockPasscodeScreen({super.key});

  @override
  State<UnlockPasscodeScreen> createState() => _UnlockPasscodeScreenState();
}

class _UnlockPasscodeScreenState extends State<UnlockPasscodeScreen> {
  String _code = '';

  void _tap(String d) {
    setState(() {
      if (_code.length < 5) _code += d;
    });
    if (_code.length == 5) {
      Future.delayed(const Duration(milliseconds: 250), () {
        if (mounted) context.go(Routes.dashboard);
      });
    }
  }

  void _back() {
    setState(() {
      if (_code.isNotEmpty) _code = _code.substring(0, _code.length - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _LockscreenShell(
      header: Column(
        children: [
          SvgPicture.asset(
            Assets.locked,
            fit: BoxFit.contain,
            height: 28,
            width: 28,
          ),
          const SizedBox(height: 14),
          Text(
            'Unlock with Your\nTransfa Passcode',
            textAlign: TextAlign.center,
            style: AppTypography.heading.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 22,
            ),
          ),
        ],
      ),
      length: 5,
      filled: _code.length,
      onKey: _tap,
      onBack: _back,
      leftButton: _PillTextButton(label: 'Cancel', onTap: () => context.pop()),
      rightButton: _PillTextButton(
        label: 'Forgot Passcode',
        onTap: () => context.push(Routes.forgotPasscode),
      ),
    );
  }
}

/// Variant with a frosted pill at top: "Security lockout after 1 try".
class SecurityLockoutScreen extends StatefulWidget {
  const SecurityLockoutScreen({super.key});

  @override
  State<SecurityLockoutScreen> createState() => _SecurityLockoutState();
}

class _SecurityLockoutState extends State<SecurityLockoutScreen> {
  String _code = '';

  void _tap(String d) {
    setState(() {
      if (_code.length < 5) _code += d;
    });
    if (_code.length == 5) {
      Future.delayed(const Duration(milliseconds: 250), () {
        if (mounted) context.go(Routes.dashboard);
      });
    }
  }

  void _back() {
    setState(() {
      if (_code.isNotEmpty) _code = _code.substring(0, _code.length - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _LockscreenShell(
      header: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.30)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(Assets.locked, width: 18, height: 18),
                const SizedBox(width: 8),
                Text(
                  'Security lockout after 1 try',
                  style: AppTypography.body.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Unlock with Your\nTransfa Passcode',
            textAlign: TextAlign.center,
            style: AppTypography.heading.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 22,
            ),
          ),
        ],
      ),
      length: 5,
      filled: _code.length,
      onKey: _tap,
      onBack: _back,
      leftButton: _PillTextButton(label: 'Cancel', onTap: () => context.pop()),
      rightButton: _PillTextButton(
        label: 'Forgot Passcode',
        onTap: () => context.push(Routes.forgotPasscode),
      ),
    );
  }
}

/// "Enter Your Transfa Passcode to Pay" — payment confirmation lockscreen
/// with a Face ID button in place of the left empty slot.
class PayPasscodeScreen extends StatefulWidget {
  const PayPasscodeScreen({super.key});

  @override
  State<PayPasscodeScreen> createState() => _PayPasscodeScreenState();
}

class _PayPasscodeScreenState extends State<PayPasscodeScreen> {
  String _code = '';

  void _tap(String d) {
    setState(() {
      if (_code.length < 5) _code += d;
    });
    if (_code.length == 5 && mounted) {
      Future.delayed(const Duration(milliseconds: 250), () {
        if (mounted) context.pushReplacement(Routes.receiptStatus);
      });
    }
  }

  void _back() {
    setState(() {
      if (_code.isNotEmpty) _code = _code.substring(0, _code.length - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WallpaperScaffold(
      darken: 0.55,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 80, 20, 28),
        child: Column(
          children: [
            SvgPicture.asset(
              Assets.locked,
              fit: BoxFit.contain,
              height: 28,
              width: 28,
            ),
            const SizedBox(height: 14),
            Text(
              'Enter Your Transfa\nPasscode to Pay',
              textAlign: TextAlign.center,
              style: AppTypography.heading.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 26),
            _Dots(length: 5, filled: _code.length),
            const SizedBox(height: 22),
            // Custom keypad row with Face ID in bottom-left.
            _PayKeypad(onTap: _tap, onBack: _back, showBack: _code.isNotEmpty),
            const Spacer(),

            Align(
              alignment: Alignment.centerLeft,
              child: _RedCancelPill(onTap: () => context.pop()),
            ),
          ],
        ),
      ),
    );
  }
}

class _PayKeypad extends StatelessWidget {
  final ValueChanged<String> onTap;
  final VoidCallback onBack;
  final bool showBack;
  const _PayKeypad({
    required this.onTap,
    required this.onBack,
    required this.showBack,
  });

  Widget _row(List<String> keys) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: keys
          .map((k) => KeypadButton(digit: k, onTap: () => onTap(k)))
          .toList(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _row(['1', '2', '3']),
        _row(['4', '5', '6']),
        _row(['7', '8', '9']),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 78,
                height: 78,
                child: IconButton(
                  onPressed: () {
                    context.push(Routes.faceShotUnlock);
                  },
                  icon: SvgPicture.asset(
                    Assets.faceId,
                    width: 34,
                    height: 34,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              KeypadButton(digit: '0', onTap: () => onTap('0')),
              SizedBox(
                width: 78,
                child: showBack
                    ? IconButton(
                        onPressed: onBack,
                        icon: const Icon(
                          Icons.backspace_outlined,
                          color: Colors.white,
                          size: 26,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Face Shot unlock — dotted circle + house emoji + Continue with Transfa.
// ---------------------------------------------------------------------------

class FaceShotUnlockScreen extends StatefulWidget {
  const FaceShotUnlockScreen({super.key});

  @override
  State<FaceShotUnlockScreen> createState() => _FaceShotUnlockScreenState();
}

class _FaceShotUnlockScreenState extends State<FaceShotUnlockScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundAlt,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 80, 24, 28),
          child: Column(
            children: [
              const SizedBox(height: 16),
              AnimatedBuilder(
                animation: _c,
                builder: (_, _) => CustomPaint(
                  size: const Size(320, 320),
                  painter: _DottedRingPainter(progress: _c.value),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 100,
                height: 100,
                child: Image.asset(Assets.welcomeHome, width: 98, height: 98),
              ),
              const SizedBox(height: 6),
              Text(
                'Welcome Home',
                style: AppTypography.subheading.copyWith(
                  color: const Color(0xFF8E8E93),
                  fontWeight: FontWeight.w500,
                  fontSize: 21,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Unlock with your face',
                style: AppTypography.displayMedium.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 26,
                ),
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: PillButton(
                  label: 'Continue with Transfa',
                  variant: PillVariant.dark,
                  leading: const TransfaMark(size: 22, white: true),
                  onPressed: () => context.push(Routes.photoId),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DottedRingPainter extends CustomPainter {
  final double progress;
  _DottedRingPainter({required this.progress});

  static const _colors = [
    AppColors.success,
    Color(0xFFFF9F0A),
    Color(0xFFFF375F),
    Color(0xFFAF52DE),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2 - 8;
    const total = 40;
    final dotPaint = Paint()..color = const Color(0xFFDFDFDF);
    final anchorIdx = [
      (5 + (progress * 0.5 * total).round()) % total,
      (15 + (progress * 0.5 * total).round()) % total,
      (25 + (progress * 0.5 * total).round()) % total,
      (35 + (progress * 0.5 * total).round()) % total,
    ];
    for (var i = 0; i < total; i++) {
      final angle = -pi / 2 + (i / total) * 2 * pi;
      final dotCenter = Offset(c.dx + r * cos(angle), c.dy + r * sin(angle));
      final anchor = anchorIdx.indexOf(i);
      if (anchor >= 0) {
        final p = Paint()..color = _colors[anchor];
        canvas.drawCircle(dotCenter, 7, p);
      } else {
        canvas.drawCircle(dotCenter, 5, dotPaint);
      }
    }
    canvas.drawCircle(c, r - 18, Paint()..color = const Color(0xFFE9E9E9));
  }

  @override
  bool shouldRepaint(covariant _DottedRingPainter old) =>
      old.progress != progress;
}

class _DarkPill extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _DarkPill({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 28),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(32),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTypography.subheading.copyWith(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Welcome Home — Unlock with phone modal.
// ---------------------------------------------------------------------------

class WelcomeHomePhoneScreen extends StatefulWidget {
  const WelcomeHomePhoneScreen({super.key});

  @override
  State<WelcomeHomePhoneScreen> createState() => _WelcomeHomePhoneScreenState();
}

class _WelcomeHomePhoneScreenState extends State<WelcomeHomePhoneScreen> {
  final _phone = TextEditingController(text: '0703 208 4888');

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECECEC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: _GlassWrapper(
                  child: Column(
                    children: [
                      Image.asset(Assets.welcomeHome, width: 72, height: 72),
                      const SizedBox(height: 4),
                      Text(
                        'Welcome Home',
                        style: AppTypography.subheading.copyWith(
                          color: const Color(0xFF8E8E93),
                          fontWeight: FontWeight.w500,
                          fontSize: 21,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Unlock with your phone',
                        style: AppTypography.displayMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 21,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 22),
              _GlassWrapper(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(height: 35),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: SizedBox(
                            width: 32,
                            height: 26,
                            child: SvgPicture.asset(
                              Assets.Nigerian_Flag,
                              width: 40,
                              height: 30,
                            ),
                          ),
                        ),
                        const SizedBox(width: 7),
                        Text(
                          'Nigeria',
                          style: AppTypography.subheading.copyWith(
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _PhoneField(controller: _phone),
                    const SizedBox(height: 18),
                    _RedLockPill(
                      label: 'Transfa Passcode',
                      onTap: () => context.push(Routes.unlockPasscode),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _BottomSquare(
                    label: 'New\nTransfa',
                    onTap: () => context.push(Routes.onboarding),
                    child: SvgPicture.asset(
                      Assets.logoChromatic,
                      width: 30,
                      height: 30,
                    ),
                  ),
                  const SizedBox(width: 18),
                  _BottomSquare(
                    label: 'Unlock\nwith Face',
                    onTap: () => context.push(Routes.faceShotUnlock),
                    child: SvgPicture.asset(
                      Assets.faceId,
                      width: 30,
                      height: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8), // Small bottom padding
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassWrapper extends StatelessWidget {
  final Widget child;
  const _GlassWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 236, 236, 236),
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 0.6),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.6),
            blurRadius: 12,
            offset: const Offset(-6, -6),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(8, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _PhoneField extends StatelessWidget {
  final TextEditingController controller;
  const _PhoneField({required this.controller});

  String _formatPhoneNumber(String value) {
    final digits = value.replaceAll(RegExp(r'\s'), '');
    if (digits.isEmpty) return '';

    final buffer = StringBuffer();
    for (int i = 0; i < digits.length && i < 11; i++) {
      if (i == 4 || i == 8) {
        buffer.write(' ');
      }
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 241, 241, 241),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,

            alignment: Alignment.center,
            child: SvgPicture.asset(Assets.phoneRound, width: 30, height: 30),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                  _PhoneInputFormatter(),
                ],
                style: AppTypography.subheading.copyWith(fontSize: 17),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (value) {
                  final formatted = _formatPhoneNumber(value);
                  if (formatted != value) {
                    controller.value = TextEditingValue(
                      text: formatted,
                      selection: TextSelection.collapsed(
                        offset: formatted.length,
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          const AnimatedDottedLoader(),
        ],
      ),
    );
  }
}

class _PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\s'), '');
    if (digits.length > 11) {
      final truncated = digits.substring(0, 11);
      return TextEditingValue(
        text: truncated,
        selection: TextSelection.collapsed(offset: truncated.length),
      );
    }
    return newValue;
  }
}

class _RedLockPill extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _RedLockPill({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF4466), Color(0xFFF41E42)],
          ),
          borderRadius: BorderRadius.circular(40),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(Assets.locked, width: 20, height: 20),
            const SizedBox(width: 10),
            Text(
              label,
              style: AppTypography.subheading.copyWith(
                color: Colors.white,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomSquare extends StatelessWidget {
  final Widget child;
  final String label;
  final VoidCallback onTap;
  const _BottomSquare({
    required this.child,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 124,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 240, 240, 240),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFFFFFFF), width: 0.6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            child,
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTypography.body.copyWith(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Forgot Passcode modal — phone re-entry to receive a new passcode.
// ---------------------------------------------------------------------------

class ForgotPasscodeScreen extends StatefulWidget {
  const ForgotPasscodeScreen({super.key});

  @override
  State<ForgotPasscodeScreen> createState() => _ForgotPasscodeScreenState();
}

class _ForgotPasscodeScreenState extends State<ForgotPasscodeScreen> {
  final _phone = TextEditingController();

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  String _formatPhoneNumber(String value) {
    final digits = value.replaceAll(RegExp(r'\s'), '');
    if (digits.isEmpty) return '';

    final buffer = StringBuffer();
    for (int i = 0; i < digits.length && i < 11; i++) {
      if (i == 4 || i == 8) {
        buffer.write(' ');
      }
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final canContinue = _phone.text.replaceAll(RegExp(r'\s'), '').length >= 10;

    return Scaffold(
      backgroundColor: const Color(0xFFECECEC),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 58, 20, 28),
          children: [
            _GlassWrapper(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(Assets.allPasscodes, width: 60, height: 60),
                  const SizedBox(height: 18),
                  Text(
                    'Forgot Passcode',
                    style: AppTypography.displayMedium.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Verify your phone number to get a\nNew Transfa Passcode.',
                    style: AppTypography.body.copyWith(fontSize: 17),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            _GlassWrapper(
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 32,
                        height: 16,
                        child: SvgPicture.asset(
                          Assets.Nigerian_Flag,
                          width: 40,
                          height: 30,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Nigeria',
                        style: AppTypography.subheading.copyWith(fontSize: 17),
                      ),
                      const Spacer(),
                      SvgPicture.asset(
                        Assets.locationAlt,
                        width: 20,
                        height: 30,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 25,
                          height: 25,

                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            Assets.phoneRound,
                            width: 25,
                            height: 25,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _phone,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(11),
                              _PhoneInputFormatter(),
                            ],
                            onChanged: (value) {
                              final formatted = _formatPhoneNumber(value);
                              if (formatted != value) {
                                _phone.value = TextEditingValue(
                                  text: formatted,
                                  selection: TextSelection.collapsed(
                                    offset: formatted.length,
                                  ),
                                );
                              }
                              setState(() {});
                            },
                            style: AppTypography.subheading.copyWith(
                              fontSize: 20,
                            ),
                            decoration: InputDecoration(
                              hintText: '0703 208 4888',
                              hintStyle: AppTypography.subheading.copyWith(
                                color: const Color(0xFFBDBDBD),
                                fontSize: 18,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFD9D9D9)),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.black,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => context.pop(),
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Cancel',
                              style: AppTypography.subheading.copyWith(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Opacity(
                          opacity: canContinue ? 1 : 0.45,
                          child: GestureDetector(
                            onTap: canContinue
                                ? () => context.push(Routes.recoveryStartkey)
                                : null,
                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFF7088),
                                    Color(0xFFF41E42),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(32),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Continue',
                                style: AppTypography.subheading.copyWith(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Recovery Startkey — same flow as Verify Startkey but with the red lock
// glyph in the header card (used during the Forgot Passcode recovery).
// ---------------------------------------------------------------------------

class RecoveryStartkeyScreen extends StatelessWidget {
  const RecoveryStartkeyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECECEC),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
          children: [
            _GlassWrapper(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(Assets.allPasscodes, width: 60, height: 60),
                  const SizedBox(height: 18),
                  Text(
                    'Verify Your Startkey',
                    style: AppTypography.displayMedium.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Transfa sent your Startkey to your\nphone: 0703 208 4888.',
                    style: AppTypography.body.copyWith(fontSize: 17),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _GlassWrapper(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Enter the Startkey here',
                        style: AppTypography.subheading.copyWith(fontSize: 17),
                      ),
                      SizedBox(width: 10),
                      AnimatedDottedLoader(),
                    ],
                  ),

                  const SizedBox(height: 56),
                  Padding(
                    padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        6,
                        (_) => Container(
                          width: 30,
                          height: 3,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                ],
              ),
            ),
            const SizedBox(height: 100),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: _GlassWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Missing the Key?',
                      style: AppTypography.subheading.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 14),
                    _ActionRow(
                      icon: SvgPicture.asset(
                        Assets.memoReady,
                        width: 20,
                        height: 20,
                      ),
                      label: 'Send New Startkey',
                      onTap: () {},
                    ),
                    const SizedBox(height: 10),
                    _ActionRow(
                      icon: SvgPicture.asset(
                        Assets.checks,
                        width: 20,
                        height: 20,
                      ),
                      label: 'Cancel',
                      onTap: () => context.pop(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final SvgPicture icon;
  final String label;
  final VoidCallback onTap;
  const _ActionRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            icon,

            const SizedBox(width: 10),
            Text(
              label,
              style: AppTypography.subheading.copyWith(
                color: const Color(0xFFF41E42),
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
