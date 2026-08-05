import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/assets.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/transfa_modal_header.dart';
import '../../../shared/widgets/wallpaper_scaffold.dart';

/// "Memo" — lockscreen-style support chat. Frosted header card with the
/// green Memo icon + title, alternating bubbles (agent frosted, user
/// green), and a frosted compose pill with home pill (left) + faded send
/// (right) anchored to the bottom.
class MemoChatScreen extends StatefulWidget {
  const MemoChatScreen({super.key});

  @override
  State<MemoChatScreen> createState() => _MemoChatScreenState();
}

class _MemoChatScreenState extends State<MemoChatScreen> {
  final _input = TextEditingController();

  static const _messages = <ChatMsg>[
    ChatMsg(ChatAuthor.agent, "How's Wednesday going\nfor you, Sarah?"),
    ChatMsg(ChatAuthor.agent, 'Good morning 🌻'),
    ChatMsg(ChatAuthor.me, 'Really beautiful. I sold 20 Tees…'),
    ChatMsg(ChatAuthor.me, 'I need help with a transaction.'),
    ChatMsg(
      ChatAuthor.agent,
      'Kindly go to the transaction and\ncontinue this conversation there',
    ),
  ];

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 12),
        child: Column(
          children: [
            // Header card - now with no extra padding, it will span full width
            const ChatHeaderCard(
              iconAsset: Assets.appIconSupport,
              title: 'Transfa Support',
              subtitle: 'Get the help you need.',
            ),
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
                HomeFab(onTap: () => context.go(Routes.dashboard)),
                _SendFab(onTap: () => _input.clear(), active: false),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Shared header card used by both Memo and Air Support chats.
class ChatHeaderCard extends StatelessWidget {
  final String iconAsset;
  final String title;
  final String subtitle;
  const ChatHeaderCard({
    super.key,
    required this.iconAsset,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(35),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(
          24,
          18,
          24,
          20,
        ), // Increased left/right padding to match bubble alignment
        decoration: BoxDecoration(
          color: Color(0x1AFCFCFB),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 56,
              height: 56,
              child: Image.asset(iconAsset, fit: BoxFit.contain),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: AppTypography.displayMedium.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontSize: 32,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: AppTypography.body.copyWith(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum ChatAuthor { me, agent }

class ChatMsg {
  final ChatAuthor author;
  final String text;
  const ChatMsg(this.author, this.text);
}

class ChatBubble extends StatelessWidget {
  final ChatMsg msg;
  const ChatBubble({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    final isMe = msg.author == ChatAuthor.me;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: isMe ? _MeBubble(text: msg.text) : _AgentBubble(text: msg.text),
      ),
    );
  }
}

class _MeBubble extends StatelessWidget {
  final String text;
  const _MeBubble({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        gradient: AppColors.greenGradient,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTypography.body.copyWith(color: Colors.white, fontSize: 18),
      ),
    );
  }
}

class _AgentBubble extends StatelessWidget {
  final String text;
  const _AgentBubble({required this.text});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
          ),
          child: Text(
            text,
            style: AppTypography.body.copyWith(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}

/// Full-width frosted "Memo…" input pill (no inline buttons).
class ChatComposeField extends StatelessWidget {
  final TextEditingController controller;
  const ChatComposeField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SvgPicture.asset(
                Assets.memoGrey,
                width: 22,
                height: 22,
                fit: BoxFit.contain,
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  style: AppTypography.body.copyWith(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Memo…',
                    hintStyle: AppTypography.body.copyWith(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SendFab extends StatelessWidget {
  final VoidCallback onTap;
  final bool active;
  const _SendFab({required this.onTap, required this.active});

  @override
  Widget build(BuildContext context) {
    if (active) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: 56,
          height: 56,
          decoration: const BoxDecoration(
            gradient: AppColors.greenGradient,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Icon(
            Icons.arrow_upward_rounded,
            color: Colors.white,
            size: 26,
          ),
        ),
      );
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,

        alignment: Alignment.center,
        child: SvgPicture.asset(
          Assets.send,
          width: 56,
          height: 56,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

/// Public send-fab so the Air Support screen can reuse the green variant.
class ChatSendFab extends StatelessWidget {
  final VoidCallback onTap;
  final bool active;
  const ChatSendFab({super.key, required this.onTap, required this.active});

  @override
  Widget build(BuildContext context) => _SendFab(onTap: onTap, active: active);
}
