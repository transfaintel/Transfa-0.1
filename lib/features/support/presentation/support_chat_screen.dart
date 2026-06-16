import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/assets.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/wallpaper_scaffold.dart';
import 'memo_chat_screen.dart';

/// "Air Support" — lockscreen-style chat anchored to a specific transaction.
/// Header card uses the blue Transfa Support tile; a frosted transaction
/// card (avatar + "New Money" + amount + green down-arrow) sits underneath
/// it, followed by chat bubbles and the standard compose pill. Bottom row
/// has a receipt button (left) and an active green send (right).
class SupportChatScreen extends StatefulWidget {
  const SupportChatScreen({super.key});

  @override
  State<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  final _input = TextEditingController();

  static const _messages = <ChatMsg>[
    ChatMsg(ChatAuthor.me, "I've got no idea who sent this."),
    ChatMsg(ChatAuthor.me, 'Good morning.'),
    ChatMsg(ChatAuthor.agent, 'Hmm. Great intuition.'),
  ];

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WallpaperScaffold(
      darken: 0.30,
      blur: false,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        child: Column(
          children: [
            const SupportChatHeaderCard(
              iconAsset: Assets.appIconSupport,
              title: 'Air Support',
              subtitle: 'Get help with this money.',
            ),
            const SizedBox(height: 18),
            const _NewMoneyCard(),
            const SizedBox(height: 18),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _messages.length,
                itemBuilder: (_, i) => ChatBubble(msg: _messages[i]),
              ),
            ),
            const SizedBox(height: 8),
            ChatComposeField(controller: _input),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ReceiptFab(onTap: () => context.push(Routes.receiptStatus)),
                ChatSendFab(onTap: () => _input.clear(), active: true),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Frosted transaction card: avatar + "New Money / Magic Payma" + strike-
/// through amount + green down-arrow (received indicator / quick action).
class _NewMoneyCard extends StatelessWidget {
  const _NewMoneyCard();

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.fromLTRB(13, 0, 13, 20),
    child:  ClipRRect(
      borderRadius: BorderRadius.circular(45),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withValues(alpha: 0.30)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 26,
                    backgroundImage: AssetImage(Assets.magic),
                    backgroundColor: Colors.grey,
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('New Money',
                          style: AppTypography.body.copyWith(
                              color: AppColors.success,
                              fontSize: 17,
                              fontWeight: FontWeight.w600)),
                      Text('Magic Payma',
                          style: AppTypography.displayMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 24)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '₦250,000',
                    style: AppTypography.displayLarge.copyWith(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      // decoration: TextDecoration.lineThrough,
                      decorationColor: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.arrow_downward_rounded,
                        color: Colors.white, size: 22),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

/// Frosted circle with the receipt-bubble glyph — opens the receipt for
/// the transaction the chat is anchored to.
class _ReceiptFab extends StatelessWidget {
  final VoidCallback onTap;
  const _ReceiptFab({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.22),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.30)),
        ),
        padding: const EdgeInsets.all(14),
        child: SvgPicture.asset(Assets.receiptBubble, fit: BoxFit.contain),
      ),
    );
  }
}

class SupportChatHeaderCard extends StatelessWidget {
  final String iconAsset;
  final String title;
  final String subtitle;
  const SupportChatHeaderCard({
    super.key,
    required this.iconAsset,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
          
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 56,
                height: 56,
                child: Image.asset(iconAsset, fit: BoxFit.contain),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Text(title,
                  style: AppTypography.displayMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 20)),
              const SizedBox(height: 2),
              Text(subtitle,
                  style: AppTypography.body
                      .copyWith(color: Colors.white, fontSize: 16)),
            ])
            ],
          ),
        ),
      ),
    );
  }
}