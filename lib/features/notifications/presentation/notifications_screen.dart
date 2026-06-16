import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/assets.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/transfa_logo.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static const _darkText = Color(0xFFFCFCFB);
  static const _fadedText = 0.62;
  static const _glassAlpha = 0.14;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    body: AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(Assets.wallpaper, fit: BoxFit.cover),
          Container(color: Colors.black.withValues(alpha: 0.95)),
          SafeArea(
            bottom: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(34, 24, 34, 120),
              children: const [
                _Header(),
                SizedBox(height: 22),
                _SoftwareUpdateCard(),
                SizedBox(height: 22),
                _RecentNotificationsGroup(),
                SizedBox(height: 22),
                _AppsActivityCard(),
                SizedBox(height: 22),
                _OlderActivityCard(),
              ],
            ),
          ),
          const Positioned(
            right: 20,
            bottom: 28,
            child: SafeArea(child: _ReadPill()),
          ),
        ],
      ),
    ),
  );
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 60,
        height: 60,

        alignment: Alignment.center,
        child: SvgPicture.asset(Assets.notifications, fit: BoxFit.cover),
      ),
      const SizedBox(height: 18),
      Text(
        'Notifications',
        style: AppTypography.displayLarge.copyWith(
          color: Colors.white,
          fontSize: 36,
          fontWeight: FontWeight.w800,
        ),
      ),
    ],
  );
}

class _SoftwareUpdateCard extends StatelessWidget {
  const _SoftwareUpdateCard();

  @override
  Widget build(BuildContext context) => _DarkGlassCard(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 44,
              height: 44,

              alignment: Alignment.center,
              child: SvgPicture.asset(Assets.softwareUpdate),
            ),
            const SizedBox(width: 14),
            Text(
              'Software Update',
              style: AppTypography.body.copyWith(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Text(
          'Transfa 1.5',
          style: AppTypography.displayMedium.copyWith(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Transfa 1.5 introduces Lists for\nVendors, Pounds & Euros, plus\nother features & enhancements.',
          style: AppTypography.body.copyWith(
            color: Colors.white.withValues(
              alpha: NotificationsScreen._fadedText,
            ),
            fontSize: 16,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 18),
        GestureDetector(
          onTap: () {},
          child: Container(
            width: double.infinity,
            height: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                colors: [Color(0xFFFF4466), Color(0xFFF41E42)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF41E42).withValues(alpha: 0.30),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              'Get Transfa',
              style: AppTypography.subheading.copyWith(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _RecentNotificationsGroup extends StatelessWidget {
  const _RecentNotificationsGroup();

  @override
  Widget build(BuildContext context) => _DarkGlassCard(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    child: Column(
      children: [
        _DarkRow(
          leading: ClipOval(
            child: Image.asset(
              Assets.magic,
              width: 44,
              height: 44,
              fit: BoxFit.cover,
            ),
          ),
          title: 'Magic Payma',
          body: r'Sent $420 for Goof.',
        ),
        const SizedBox(height: 16),
        _DarkRow(
          leading: Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFF0B2E6F),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const TransfaMark(size: 22, white: true),
          ),
          title: 'Transfa Support',
          body: 'Thank you, Sarah. Do you have\nmore questions?',
        ),
        const SizedBox(height: 16),
        _DarkRow(
          leading: Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFF34C759),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.person, color: Colors.white, size: 24),
          ),
          title: 'Processing',
          titleColor: const Color(0xFFFF9F0A),
          body: 'Amadioha Obi\nSent ₦100,000,000 for\nTechnical Research Grant',
        ),
      ],
    ),
  );
}

class _AppsActivityCard extends StatelessWidget {
  const _AppsActivityCard();

  @override
  Widget build(BuildContext context) => _DarkGlassCard(
    padding: const EdgeInsets.fromLTRB(14, 18, 14, 18),
    child: Column(
      children: [
        _LightPillRow(
          leading: Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: Image.asset(Assets.internetIcon, fit: BoxFit.contain),
          ),
          title: 'Internet',
          body: 'Paid for 90 Days.',
        ),
        const SizedBox(height: 12),
        _LightBareRow(
          leading: ClipOval(
            child: Image.asset(
              Assets.avatarGrace,
              width: 44,
              height: 44,
              fit: BoxFit.cover,
            ),
          ),
          title: 'Dalia Wetzel',
          body: r'Sent N1,200,000 for BASkets',
        ),
        const SizedBox(height: 12),
        _LightBareRow(
          leading: Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFFFF9F0A),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: Image.asset(Assets.powerIcon, fit: BoxFit.contain),
          ),
          title: 'Power',
          body: 'Paid for 420 Units',
        ),
        const SizedBox(height: 12),
        _LightPillRow(
          leading: Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFFFF375F),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: Image.asset(Assets.reeplayIcon, fit: BoxFit.contain),
          ),
          title: 'Reeplay',
          body: r'Got N25,000 for Gift Card.',
        ),
        const SizedBox(height: 12),
        _LightBareRow(
          leading: Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFFFF9F0A),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.person, color: Colors.white, size: 24),
          ),
          title: 'Unable to Send',
          titleColor: const Color(0xFFFF9F0A),
          titleFaded: false,
          body: 'Obi Amadioha\n₦35,000 for April Salary',
        ),
      ],
    ),
  );
}

class _OlderActivityCard extends StatelessWidget {
  const _OlderActivityCard();

  @override
  Widget build(BuildContext context) => _DarkGlassCard(
    padding: const EdgeInsets.fromLTRB(14, 18, 14, 18),
    child: Column(
      children: [
        _LightBareRow(
          leading: Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFF34C759),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.person, color: Colors.white, size: 24),
          ),
          title: 'Julio Cesar',
          body: 'Sent N5,000 for Weekend BBQ',
        ),
        const SizedBox(height: 14),
        _LightBareRow(
          leading: ClipOval(
            child: Image.asset(
              Assets.avatarGrace,
              width: 44,
              height: 44,
              fit: BoxFit.cover,
            ),
          ),
          title: 'Janelle Hickleson',
          body: 'Sent N250,000 for August Salary',
        ),
        const SizedBox(height: 14),
        _LightBareRow(
          leading: Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFF6238FB),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.business_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          title: 'Spotify',
          body: r'Got 9.99 for July Music',
        ),
        const SizedBox(height: 14),
        _LightBareRow(
          leading: ClipOval(
            child: Image.asset(
              Assets.magic,
              width: 44,
              height: 44,
              fit: BoxFit.cover,
            ),
          ),
          title: 'Magic Payma',
          body: r'Got $250 transfa for Studio Equipment',
        ),
        const SizedBox(height: 14),
        _LightBareRow(
          leading: Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFFFF375F),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.business_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          title: 'Connectic',
          body: 'Got N12,500,000 for Bandwidth',
        ),
      ],
    ),
  );
}

class _DarkRow extends StatelessWidget {
  final Widget leading;
  final String title, body;
  final Color? titleColor;
  const _DarkRow({
    required this.leading,
    required this.title,
    required this.body,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      leading,
      const SizedBox(width: 14),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTypography.subheading.copyWith(
                color: titleColor ?? NotificationsScreen._darkText,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              body,
              style: AppTypography.body.copyWith(
                color: Colors.white.withValues(alpha: 0.88),
                fontSize: 15,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _LightBareRow extends StatelessWidget {
  final Widget leading;
  final String title, body;
  final Color? titleColor;
  final bool titleFaded;
  const _LightBareRow({
    required this.leading,
    required this.title,
    required this.body,
    this.titleColor,
    this.titleFaded = true,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        leading,
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.subheading.copyWith(
                  color: titleFaded
                      ? (titleColor ?? NotificationsScreen._darkText)
                            .withValues(alpha: 1)
                      : (titleColor ?? NotificationsScreen._darkText),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                body,
                style: AppTypography.body.copyWith(
                  color: Colors.white.withValues(alpha: 1),
                  fontSize: 15,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _LightPillRow extends StatelessWidget {
  final Widget leading;
  final String title, body;
  const _LightPillRow({
    required this.leading,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(8, 6, 18, 6),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.10),
      borderRadius: BorderRadius.circular(40),
      border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        leading,
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.subheading.copyWith(
                  color: Colors.white.withValues(alpha: 1),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                body,
                style: AppTypography.body.copyWith(
                  color: Colors.white.withValues(alpha: 1),
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _DarkGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const _DarkGlassCard({required this.child, required this.padding});

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(45),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: Colors.white.withValues(
            alpha: NotificationsScreen._glassAlpha,
          ),
          borderRadius: BorderRadius.circular(45),
          border: Border.all(color: Colors.white.withValues(alpha: 0.30)),
        ),
        child: child,
      ),
    ),
  );
}

class _ReadPill extends StatelessWidget {
  const _ReadPill();

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => context.go(Routes.dashboard),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(34),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 22, 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(34),
            border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.10),
                blurRadius: 4,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 32,
                height: 32,
                child: SvgPicture.asset(Assets.markAsRead),
              ),
              const SizedBox(width: 7),
              Text(
                'Done',
                style: AppTypography.subheading.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
