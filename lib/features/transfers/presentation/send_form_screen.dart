import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/assets.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/transfa_modal_header.dart';
import 'transfer_state.dart';

/// "Transfa send" composer card. To: recipient + bank center + send amount
/// + message + balance footer. Tap recipient row to open the picker.
class SendFormScreen extends ConsumerStatefulWidget {
  const SendFormScreen({super.key});

  @override
  ConsumerState<SendFormScreen> createState() => _SendFormScreenState();
}

class _SendFormScreenState extends ConsumerState<SendFormScreen> {
  final _memo = TextEditingController();

  @override
  void dispose() {
    _memo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(transferDraftProvider);
    final amount = draft.amount ?? 0;
    final recipient = draft.recipientName;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TransfaModalHeader(onClose: () => context.pop()),
              const SizedBox(height: 36),

              // To: recipient row
              InkWell(
                onTap: () => context.push(Routes.recipientPick),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      Text('To:',
                          style: AppTypography.subheading.copyWith(
                              color: AppColors.textMuted, fontSize: 22)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          recipient ?? 'Name or account number…',
                          style: AppTypography.subheading.copyWith(
                              color: recipient == null
                                  ? AppColors.textMuted
                                  : Colors.black,
                              fontSize: 22),
                        ),
                      ),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.person_rounded,
                            color: Colors.white, size: 22),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(color: Color(0xFFE0E0E0)),
              const SizedBox(height: 8),

              // Bank Center row
              InkWell(
                onTap: () => context.push(Routes.chooseBank),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: SvgPicture.asset(Assets.bank, fit: BoxFit.contain),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text('Bank Center',
                            style: AppTypography.subheading.copyWith(
                                color: AppColors.textMuted, fontSize: 22)),
                      ),
                      const Icon(Icons.unfold_more_rounded,
                          color: AppColors.textMuted, size: 26),
                    ],
                  ),
                ),
              ),
              const Divider(color: Color(0xFFE0E0E0)),
              const SizedBox(height: 28),

              // Send amount
              Text('Send',
                  style: AppTypography.subheading
                      .copyWith(color: AppColors.textMuted, fontSize: 22)),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () => context.pop(),
                child: RichText(
                  text: TextSpan(
                    style: AppTypography.displayLarge.copyWith(
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      decoration: amount > 0 ? TextDecoration.lineThrough : null,
                      decorationColor: Colors.black.withValues(alpha: 0.45),
                    ),
                    children: [
                      const TextSpan(text: '₦'),
                      TextSpan(text: amount > 0 ? AppFormat.ngn(amount).replaceAll('₦', '').split('.').first : '0'),
                      TextSpan(
                        text: amount > 0
                            ? '.${(amount.toStringAsFixed(2)).split('.').last}'
                            : '.00',
                        style: const TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Divider(color: Color(0xFFE0E0E0)),

              // Memo row
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.chat_bubble_rounded,
                          color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: TextField(
                        controller: _memo,
                        style: AppTypography.subheading.copyWith(fontSize: 20),
                        decoration: InputDecoration(
                          hintText: "What's the money for?",
                          hintStyle: AppTypography.subheading.copyWith(
                              color: AppColors.textMuted, fontSize: 20),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: Color(0xFFE0E0E0)),
              const SizedBox(height: 12),

              // Balance footer
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: SvgPicture.asset(Assets.logoSmallWhite, fit: BoxFit.contain),
                    ),
                  ),
                  const SizedBox(width: 12),
                  RichText(
                    text: TextSpan(
                      style: AppTypography.body.copyWith(
                          color: AppColors.textMuted, fontSize: 19),
                      children: [
                        const TextSpan(text: 'Balance: '),
                        const TextSpan(text: '₦', style: TextStyle(decoration: TextDecoration.lineThrough)),
                        const TextSpan(text: '50,000,000', style: TextStyle(decoration: TextDecoration.lineThrough)),
                        const TextSpan(text: '.00', style: TextStyle(fontSize: 14, decoration: TextDecoration.lineThrough)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
