import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui' show ImageFilter;
import '../../../core/constants/assets.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../features/pop-ups/transfaBankPrivacy_popup.dart';

class IdCollectScreen extends StatefulWidget {
  final WidgetBuilder iconBuilder;
  final String title;
  final String subtitle;
  final String placeholder;
  final String footerLookupLabel;
  final void Function(String enteredId) onContinue;

  const IdCollectScreen({
    super.key,
    required this.iconBuilder,
    required this.title,
    required this.subtitle,
    required this.placeholder,
    required this.footerLookupLabel,
    required this.onContinue,
  });

  @override
  State<IdCollectScreen> createState() => _IdCollectScreenState();
}

class _IdCollectScreenState extends State<IdCollectScreen> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _showPrivacy() {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => TransfaBankPrivacyPopup(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundAlt,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 80, 28, 32),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlassCard(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(28, 28, 28, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 56,
                        height: 56,
                        child: widget.iconBuilder(context),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        widget.title,
                        style: AppTypography.displayMedium.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 28,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        widget.subtitle,
                        style: AppTypography.body.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                GlassCard(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
                  child: Column(
                    children: [
                      _LockField(
                        controller: _ctrl,
                        placeholder: widget.placeholder,
                      ),
                      const SizedBox(height: 14),
                      _RedContinue(
                        onTap: () {
                          widget.onContinue(_ctrl.text.trim());
                        },
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _FooterPill(
                              icon: Icons.front_hand_rounded,
                              label: 'Privacy',
                              onTap: _showPrivacy,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _FooterPill(
                              icon: Icons.phone_rounded,
                              label: widget.footerLookupLabel,
                              onTap: () {},
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
        ),
      ),
    );
  }
}

class _LockField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  const _LockField({required this.controller, required this.placeholder});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 10),
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
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.lock_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
              ],
              style: AppTypography.subheading.copyWith(
                fontSize: 19,
                letterSpacing: 1.4,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: placeholder,
                hintStyle: AppTypography.subheading.copyWith(
                  fontSize: 19,
                  letterSpacing: 1.4,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textMuted,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RedContinue extends StatelessWidget {
  final VoidCallback onTap;
  const _RedContinue({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primaryLight, AppColors.primary],
          ),
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.28),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          'Verify',
          style: AppTypography.subheading.copyWith(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _FooterPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _FooterPill({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 240, 240, 240),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: const Color.fromARGB(255, 245, 245, 245)),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.black, size: 22),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTypography.subheading.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showBvnGlassPopup(
  BuildContext context, {
  required String enteredNumber,
  required VoidCallback onConfirm,
  required String idType,
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) => _BvnGlassModalContent(
      enteredNumber: enteredNumber,
      onConfirm: onConfirm,
      idType: idType,
    ),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0, 1);
      const end = Offset.zero;
      const curve = Curves.easeOutCubic;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);
      var fadeTween = Tween(
        begin: 0.0,
        end: 1.0,
      ).chain(CurveTween(curve: curve));
      var fadeAnimation = animation.drive(fadeTween);

      return FadeTransition(
        opacity: fadeAnimation,
        child: SlideTransition(position: offsetAnimation, child: child),
      );
    },
  );
}

class _BvnGlassModalContent extends StatelessWidget {
  final String enteredNumber;
  final VoidCallback onConfirm;
  final String idType;

  const _BvnGlassModalContent({
    required this.enteredNumber,
    required this.onConfirm,
    required this.idType,
  });

  @override
  Widget build(BuildContext context) {
    String displayBvn = enteredNumber.replaceAll(RegExp(r'\s'), '');
    if (displayBvn.length == 11) {
      displayBvn =
          '${displayBvn.substring(0, 4)} ${displayBvn.substring(4, 8)} ${displayBvn.substring(8)}';
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            constraints: const BoxConstraints(maxWidth: 378),
            height: 540,
            decoration: BoxDecoration(
              color: const Color(0x80FCFCFB),
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
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0x20FFFFFF),
                    borderRadius: BorderRadius.circular(45),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 80,
                          height: 65,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.6),
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            Assets.avatar,
                            width: 40,
                            height: 40,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Barry Bontulipo',
                          style: AppTypography.displayMedium.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 28,
                            color: const Color(0xFF1A2C3E),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.8),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                Assets.Nigerian_Flag,
                                width: 24,
                                height: 24,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Nigerian',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.8,
                                  color: Color(0xFF6B7A8A),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        _StatusSummaryCard(total: "0", idType: idType),
                        const SizedBox(height: 22),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                              onConfirm();
                            },
                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    AppColors.primaryLight,
                                    AppColors.primary,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(40),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.28,
                                    ),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Continue',
                                style: AppTypography.subheading.copyWith(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                      ],
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

class AddBvnScreen extends StatelessWidget {
  const AddBvnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IdCollectScreen(
      iconBuilder: (_) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: Image.asset(Assets.cbnLogo, fit: BoxFit.contain),
      ),
      title: 'Add Your BVN',
      subtitle:
          'Earn money across Nigeria and\naccess banking & capital services.',
      placeholder: '0000 1111 0000 2222',
      footerLookupLabel: 'My BVN',
      onContinue: (enteredNumber) {
        showBvnGlassPopup(
          context,
          enteredNumber: enteredNumber,
          idType: 'BVN',
          onConfirm: () {
            context.push(Routes.identityVerification);
          },
        );
      },
    );
  }
}

class AddNinScreen extends StatelessWidget {
  const AddNinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IdCollectScreen(
      iconBuilder: (_) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: Image.asset(Assets.nimcLogo, fit: BoxFit.contain),
      ),
      title: 'Add Your NIN',
      subtitle:
          'Earn money across Nigeria and\naccess banking & capital services.',
      placeholder: '0000 1111 0000 2222',
      footerLookupLabel: 'My NIN',
      onContinue: (enteredBvn) {
        showBvnGlassPopup(
          context,
          enteredNumber: enteredBvn,
          idType: 'NIN',
          onConfirm: () {
            context.push(Routes.identityVerification);
          },
        );
      },
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final bool labelBold;
  final Widget value;
  final String icon;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.icon,
    this.labelBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Row(
            children: [
              SvgPicture.asset(
                icon,
                width: 30,
                height: 30,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTypography.subheading.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: labelBold ? Colors.black : AppColors.textMuted,
                ),
              ),
            ],
          ),
          const Spacer(),
          value,
        ],
      ),
    );
  }
}

class _StatusSummaryCard extends StatelessWidget {
  final String total;
  final String idType;
  const _StatusSummaryCard({required this.total, required this.idType});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          _SummaryRow(
            label: 'Born',
            icon: Assets.birthdayCake,
            labelBold: true,
            value: Text(
              "Friday, December 10",
              style: AppTypography.body.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),

          idType == 'BVN'
              ? _SummaryRow(
                  label: 'BVN',
                  icon: Assets.nationalID,
                  labelBold: true,
                  value: Text(
                    "0000 1111 0000 2222",
                    style: AppTypography.subheading.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                )
              : _SummaryRow(
                  label: 'NIN',
                  icon: Assets.nationalID,
                  labelBold: true,
                  value: Text(
                    "0000 1111 0000 2222",
                    style: AppTypography.subheading.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
// class _SoftCancel extends StatelessWidget {
//   final VoidCallback onTap;
//   const _SoftCancel({required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: 60,
//         decoration: BoxDecoration(
//           color: const Color(0xFFEDEDED),
//           borderRadius: BorderRadius.circular(40),
//         ),
//         alignment: Alignment.center,
//         child: Text(
//           'Cancel',
//           style: AppTypography.subheading.copyWith(
//             color: Colors.black,
//             fontSize: 20,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//     );
//   }
// }
