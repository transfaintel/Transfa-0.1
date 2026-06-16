import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../features/pop-ups/bank_unavailable_popup.dart';
// ignore_for_file: unnecessary_import

import '../../../core/constants/assets.dart';
import '../../../core/theme/app_typography.dart';

class ChooseBankScreen extends StatefulWidget {
  const ChooseBankScreen({super.key});

  @override
  State<ChooseBankScreen> createState() => _ChooseBankScreenState();
}

class _ChooseBankScreenState extends State<ChooseBankScreen> {
  final TextEditingController _search = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  String _query = '';

  static const List<_Bank> _all = [
    _Bank('Chase', _Logo.chase),
    _Bank('OPay', _Logo.opay),
    _Bank('FCMB', _Logo.fcmb),
    _Bank('GTBank', _Logo.gtb),
    _Bank('Access Bank', _Logo.access),
    _Bank('First Bank', _Logo.firstBank),
    _Bank('Zenith Bank', _Logo.zenith),
    _Bank('UBA', _Logo.uba),
    _Bank('Kuda', _Logo.kuda),
    _Bank('Wema Bank', _Logo.wema),
    _Bank('Sterling Bank', _Logo.sterling),
    _Bank('PalmPay', _Logo.palmpay),
    _Bank('Moneypoint', _Logo.moneypoint),
    _Bank('Stanbic IBTC', _Logo.stanbic),
    _Bank('Union Bank', _Logo.union),
  ];

  static const List<_Bank> _suggestions = [
    _Bank('Chase', _Logo.chase),
    _Bank('OPay', _Logo.opay),
    _Bank('FCMB', _Logo.fcmb),
  ];

  // Add this method inside _ChooseBankScreenState
void _handleBankSelection(_Bank bank) {
  if (bank.name == 'OPay') {
    // Show the bank unavailable popup
    showBankUnavailablePopup(
      context,
      bankName: bank.name,
      onContinueWithTransfa: () {
        
        debugPrint('Continue with Transfa for ${bank.name}');
      },
    );
  } else {
    // Normal bank selection
    context.pop(bank.name);
  }
}

  @override
  void initState() {
    super.initState();
    _search.addListener(() {
      final q = _search.text.trim();
      if (q != _query) setState(() => _query = q);
    });
  }

  @override
  void dispose() {
    _search.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  List<_Bank> get _filtered {
    if (_query.isEmpty) return _all;
    final q = _query.toLowerCase();
    return _all.where((b) => b.name.toLowerCase().contains(q)).toList();
  }

  void _pick(_Bank b) => _handleBankSelection(b);

  @override
  Widget build(BuildContext context) {
    final searching = _query.isNotEmpty;
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFF1),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 140),
              children: [
                // Top-right close affordance.
                
                const _HeroCard(),
                const SizedBox(height: 28),

                // ---------- Suggestions (hidden while searching) ----------
                if (!searching) ...[
                  const _SectionHeader(
                    label: 'Suggestions',
                    glyph: _SectionGlyph.suggestions,
                  ),
                  const SizedBox(height: 14),
                  _GroupedCard(
                    children: [
                      for (var i = 0; i < _suggestions.length; i++)
                        _BankRow(
                          bank: _suggestions[i],
                          highlighted: i == 0,
                          showDivider: i < _suggestions.length - 1,
                          onTap: () => _pick(_suggestions[i]),
                        ),
                    ],
                  ),
                  const SizedBox(height: 28),
                ],

                // ---------- All Banks ----------
                const _SectionHeader(
                  label: 'All Banks',
                  glyph: _SectionGlyph.bank,
                ),
                const SizedBox(height: 14),
                _GroupedCard(
                  children: [
                    if (_filtered.isEmpty)
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(20, 22, 20, 22),
                        child: Text(
                          'No banks match "$_query"',
                          style: AppTypography.body.copyWith(
                            color: Colors.black54,
                            fontSize: 15,
                          ),
                        ),
                      )
                    else
                      for (var i = 0; i < _filtered.length; i++)
                        _BankRow(
                          bank: _filtered[i],
                          showDivider: i < _filtered.length - 1,
                          onTap: () => _pick(_filtered[i]),
                        ),
                  ],
                ),
              ],
            ),

            // ---------- Floating glass search bar ----------
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: _FloatingSearchBar(
                controller: _search,
                focusNode: _searchFocus,
                hasQuery: searching,
                onClear: () {
                  _search.clear();
                  _searchFocus.unfocus();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
//  Hero info card
// ============================================================

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 26),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Green app-icon tile with white columns bank glyph.
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Color(0xFF07B826), Color(0xFF4EE659)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF07B826).withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: SizedBox(
              width: 30,
              height: 30,
              child: SvgPicture.asset(
                Assets.bank,
                fit: BoxFit.contain,
                colorFilter: const ColorFilter.mode(
                    Colors.white, BlendMode.srcIn),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Bank Center',
            style: AppTypography.displayMedium.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 26,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Transfa finds accounts instantly. You can also find a bank manually.',
            style: AppTypography.body.copyWith(
              fontSize: 16,
              height: 1.35,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
//  Section header (icon + label)
// ============================================================

enum _SectionGlyph { suggestions, bank }

class _SectionHeader extends StatelessWidget {
  final String label;
  final _SectionGlyph glyph;
  const _SectionHeader({required this.label, required this.glyph});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        children: [
          SizedBox(
            width: 22,
            height: 22,
            child: glyph == _SectionGlyph.suggestions
                ? const _SuggestionsGlyph()
                : SvgPicture.asset(
                    Assets.bank,
                    fit: BoxFit.contain,
                    colorFilter: const ColorFilter.mode(
                        Colors.black, BlendMode.srcIn),
                  ),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: AppTypography.subheading.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

/// Stylised person + sparkle glyph used by the Suggestions section header.
class _SuggestionsGlyph extends StatelessWidget {
  const _SuggestionsGlyph();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Positioned(
          left: 0,
          bottom: 0,
          child: Icon(Icons.person, size: 22, color: Colors.black),
        ),
        Positioned(
          right: -2,
          top: -2,
          child: CustomPaint(
            size: const Size(10, 10),
            painter: _SparklePainter(),
          ),
        ),
      ],
    );
  }
}

class _SparklePainter extends CustomPainter {
  const _SparklePainter();
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = Colors.black;
    final cx = size.width / 2, cy = size.height / 2;
    final path = Path()
      ..moveTo(cx, 0)
      ..lineTo(cx + 1.5, cy - 1.5)
      ..lineTo(size.width, cy)
      ..lineTo(cx + 1.5, cy + 1.5)
      ..lineTo(cx, size.height)
      ..lineTo(cx - 1.5, cy + 1.5)
      ..lineTo(0, cy)
      ..lineTo(cx - 1.5, cy - 1.5)
      ..close();
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============================================================
//  Grouped white card (rounded list container)
// ============================================================

class _GroupedCard extends StatelessWidget {
  final List<Widget> children;
  const _GroupedCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(children: children),
    );
  }
}

// ============================================================
//  Bank row
// ============================================================

class _BankRow extends StatelessWidget {
  final _Bank bank;
  final bool highlighted;
  final bool showDivider;
  final VoidCallback onTap;
  const _BankRow({
    required this.bank,
    required this.onTap,
    this.highlighted = false,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          child: Material(
            color: highlighted
                ? const Color(0xFFE5E5E7)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(28),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(28),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
                child: Row(
                  children: [
                    _BankAvatar(logo: bank.logo),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        bank.name,
                        style: AppTypography.subheading.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (showDivider && !highlighted)
          Padding(
            padding: const EdgeInsets.only(left: 72, right: 18),
            child: Container(
              height: 0.6,
              color: Colors.black.withValues(alpha: 0.06),
            ),
          ),
      ],
    );
  }
}

// ============================================================
//  Search pill
// ============================================================

/// Bottom floating search bar — a frosted glass pill on the left holding the
/// search field, with a separate frosted glass circular X button on the
/// right. Both float over the scrolling bank list with their own backdrop
/// blur + neumorphic shadow, so the list shows through behind them.
class _FloatingSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onClear;
  final bool hasQuery;
  const _FloatingSearchBar({
    required this.controller,
    required this.focusNode,
    required this.onClear,
    required this.hasQuery,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Search pill — separate glass element. Icon + "Search" hint are
        // centered within the pill (Stack: a centered placeholder layered
        // over a centered TextField). Once the user types, the typed text
        // flows out from the centre and the placeholder disappears.

        GestureDetector(
          onTap: () {
            if (hasQuery || focusNode.hasFocus) {
              onClear();
            } else {
              Navigator.of(context).maybePop();
            }
          },
          behavior: HitTestBehavior.opaque,
          child: _GlassShell(
            borderRadius: 28,
            height: 56,
            width: 56,
            child: Center(
              child: SvgPicture.asset(
                Assets.paySheet,
                width: 20,
                height: 20,
                fit: BoxFit.contain,
                colorFilter: ColorFilter.mode(
                    Colors.black54, BlendMode.srcIn),
              ),
            ),
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: _GlassShell(
            borderRadius: 30,
            height: 56,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    textInputAction: TextInputAction.search,
                    textAlign: TextAlign.center,
                    style: AppTypography.body.copyWith(
                      fontSize: 17,
                      color: Colors.black,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isCollapsed: true,
                    ),
                  ),
                ),
                if (!hasQuery)
                  IgnorePointer(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search_rounded,
                          size: 20,
                          color: Colors.black.withValues(alpha: 0.55),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Search',
                          style: AppTypography.body.copyWith(
                            fontSize: 17,
                            color: Colors.black.withValues(alpha: 0.45),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        
      ],
    );
  }
}

/// Reusable frosted-glass shell — translucent white fill, soft border, and
/// a dual shadow (light highlight + dark drop) so the surface reads as a
/// raised glass capsule over the list behind it.
class _GlassShell extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double height;
  final double? width;
  const _GlassShell({
    required this.child,
    required this.borderRadius,
    required this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.7),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.6),
                blurRadius: 4,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

// ============================================================
//  Bank model + avatar rendering
// ============================================================

enum _Logo {
  chase,
  opay,
  fcmb,
  gtb,
  access,
  firstBank,
  zenith,
  uba,
  kuda,
  wema,
  sterling,
  palmpay,
  moneypoint,
  stanbic,
  union,
}

class _Bank {
  final String name;
  final _Logo logo;
  const _Bank(this.name, this.logo);
}

class _BankAvatar extends StatelessWidget {
  final _Logo logo;
  const _BankAvatar({required this.logo});

  @override
  Widget build(BuildContext context) {
    final size = 40.0;
    switch (logo) {
      case _Logo.opay:
        return ClipOval(
          child: Image.asset(Assets.bankOpay,
              width: size, height: size, fit: BoxFit.cover),
        );
      case _Logo.fcmb:
        return ClipOval(
          child: Image.asset(Assets.bankFcmb,
              width: size, height: size, fit: BoxFit.cover),
        );
      case _Logo.chase:
        return Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            color: Color(0xFFEAEAEE),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(9),
          child: const CustomPaint(painter: _ChaseLogoPainter()),
        );
      case _Logo.gtb:
        return _InitialAvatar(
            initials: 'GT',
            bg: const Color(0xFFE85A1F),
            fg: Colors.white);
      case _Logo.access:
        return _InitialAvatar(
            initials: 'AB',
            bg: const Color(0xFFEF3E33),
            fg: Colors.white);
      case _Logo.firstBank:
        return _InitialAvatar(
            initials: 'FB',
            bg: const Color(0xFF003B71),
            fg: Colors.white);
      case _Logo.zenith:
        return _InitialAvatar(
            initials: 'ZB',
            bg: const Color(0xFFE60012),
            fg: Colors.white);
      case _Logo.uba:
        return _InitialAvatar(
            initials: 'U',
            bg: const Color(0xFFCC0000),
            fg: Colors.white);
      case _Logo.kuda:
        return _InitialAvatar(
            initials: 'K',
            bg: const Color(0xFF40196D),
            fg: Colors.white);
      case _Logo.wema:
        return _InitialAvatar(
            initials: 'W',
            bg: const Color(0xFF6F2C91),
            fg: Colors.white);
      case _Logo.sterling:
        return _InitialAvatar(
            initials: 'S',
            bg: const Color(0xFFD8232A),
            fg: Colors.white);
      case _Logo.palmpay:
        return _InitialAvatar(
            initials: 'P',
            bg: const Color(0xFF6238FB),
            fg: Colors.white);
      case _Logo.moneypoint:
        return _InitialAvatar(
            initials: 'M',
            bg: const Color(0xFF0357EE),
            fg: Colors.white);
      case _Logo.stanbic:
        return _InitialAvatar(
            initials: 'SI',
            bg: const Color(0xFF0033A0),
            fg: Colors.white);
      case _Logo.union:
        return _InitialAvatar(
            initials: 'UB',
            bg: const Color(0xFF003E7E),
            fg: Colors.white);
    }
  }
}

class _InitialAvatar extends StatelessWidget {
  final String initials;
  final Color bg;
  final Color fg;
  const _InitialAvatar(
      {required this.initials, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: AppTypography.caption.copyWith(
          color: fg,
          fontWeight: FontWeight.w800,
          fontSize: 13,
        ),
      ),
    );
  }
}

/// Mini Chase quadrant logo — four blue trapezoidal blades around an
/// empty center, painted directly so we don't need a bitmap asset.
class _ChaseLogoPainter extends CustomPainter {
  const _ChaseLogoPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final blue = Paint()..color = const Color(0xFF1976D2);
    final w = size.width, h = size.height;
    final cx = w / 2, cy = h / 2;
    final inset = w * 0.18;
    // Top blade
    canvas.drawPath(
      Path()
        ..moveTo(cx - inset, 0)
        ..lineTo(cx + inset, 0)
        ..lineTo(cx + inset, cy - inset)
        ..lineTo(cx - inset, cy - inset)
        ..close(),
      blue,
    );
    // Right blade
    canvas.drawPath(
      Path()
        ..moveTo(w, cy - inset)
        ..lineTo(w, cy + inset)
        ..lineTo(cx + inset, cy + inset)
        ..lineTo(cx + inset, cy - inset)
        ..close(),
      blue,
    );
    // Bottom blade
    canvas.drawPath(
      Path()
        ..moveTo(cx + inset, h)
        ..lineTo(cx - inset, h)
        ..lineTo(cx - inset, cy + inset)
        ..lineTo(cx + inset, cy + inset)
        ..close(),
      blue,
    );
    // Left blade
    canvas.drawPath(
      Path()
        ..moveTo(0, cy + inset)
        ..lineTo(0, cy - inset)
        ..lineTo(cx - inset, cy - inset)
        ..lineTo(cx - inset, cy + inset)
        ..close(),
      blue,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
