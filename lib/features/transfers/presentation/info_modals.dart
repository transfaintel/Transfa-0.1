import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

import '../../../shared/widgets/info_modal_card.dart';
import '../../../shared/widgets/pill_button.dart';
import '../../../shared/widgets/transfa_logo.dart';

// ---------------------------------------------------------------------------
// Reusable icon glyphs used across these modals.
// ---------------------------------------------------------------------------

class _NoSignalIcon extends StatelessWidget {
  const _NoSignalIcon();

  @override
  Widget build(BuildContext context) {
    return const AppIconTile(
      color: AppColors.success,
      child: Icon(Icons.signal_cellular_nodata_rounded,
          color: Colors.white, size: 32),
    );
  }
}

class _StampDutyIcon extends StatelessWidget {
  const _StampDutyIcon();

  @override
  Widget build(BuildContext context) {
    return AppIconTile(
      color: Colors.transparent,
      child: Container(
        width: 60,
        height: 60,
        alignment: Alignment.center,
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(Icons.shield_moon_rounded, color: Color(0xFF1A6B2C), size: 56),
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: Color(0xFFFFB347),
                shape: BoxShape.circle,
              ),
            ),
            const Icon(Icons.flag_rounded, color: Color(0xFF1A6B2C), size: 20),
          ],
        ),
      ),
    );
  }
}

class _FaceIcon extends StatelessWidget {
  const _FaceIcon();

  @override
  Widget build(BuildContext context) {
    return const AppIconTile(
      color: AppColors.success,
      child: Icon(Icons.tag_faces_rounded, color: Colors.white, size: 36),
    );
  }
}

class _PowerIcon extends StatelessWidget {
  const _PowerIcon();

  @override
  Widget build(BuildContext context) {
    return const AppIconTile(
      gradient: LinearGradient(
        colors: [Color(0xFFFFB347), Color(0xFFFF7A00)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      child: Icon(Icons.lightbulb_rounded, color: Colors.white, size: 32),
    );
  }
}

// ---------------------------------------------------------------------------
// "Bank Unavailable" — payment couldn't be sent via the chosen bank.
// ---------------------------------------------------------------------------
class BankUnavailableScreen extends StatelessWidget {
  const BankUnavailableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoModalCard(
      icon: const _NoSignalIcon(),
      title: 'Bank Unavailable',
      body:
          'The money could not be\nsent because "Wema" is\nunavailable.\nContinue with Transfa?',
      rows: [
        CheckRow(
          leading: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: const TransfaMark(size: 18, white: true),
          ),
          label: 'Transfa',
          selected: true,
        ),
      ],
      actions: [
        PillButton(label: 'Continue', onPressed: () => context.pop()),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// "No Internet" — Wi-Fi / cellular fallback prompt.
// ---------------------------------------------------------------------------
class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoModalCard(
      icon: const _NoSignalIcon(),
      title: 'No Internet',
      body: 'Connect to a Wi-Fi network\nor cellular data to continue.',
      actions: [
        PillButton(label: 'Wi-Fi Settings', variant: PillVariant.secondary, onPressed: () {}),
        PillButton(label: 'Cellular Settings', variant: PillVariant.secondary, onPressed: () {}),
        PillButton(label: 'Cancel', onPressed: () => context.pop()),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// "Insufficient Money" — wallet balance too low.
// ---------------------------------------------------------------------------
class InsufficientMoneyScreen extends StatelessWidget {
  const InsufficientMoneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoModalCard(
      icon: const _NoSignalIcon(),
      title: 'Insufficient Money',
      body: 'To pay instantly, add money\nto your Transfa.',
      rows: [
        ActionPillRow(
          leading: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: const TransfaMark(size: 18, white: true),
          ),
          label: 'Transfa',
          actionLabel: 'Add',
          onAction: () => context.pop(),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// "Stamp Duty" — informational tax notice.
// ---------------------------------------------------------------------------
class StampDutyScreen extends StatelessWidget {
  const StampDutyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoModalCard(
      icon: const _StampDutyIcon(),
      title: 'Stamp Duty',
      body:
          'From January 1, 2026,\npayments above ₦10,000\nincur a ₦50 "Stamp Duty"\nunder Nigeria\'s Tax Law.',
      actions: [
        PillButton(label: 'OK', onPressed: () => context.pop()),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// "Face Not Recognized" — biometric fallback prompt.
// ---------------------------------------------------------------------------
class FaceNotRecognizedScreen extends StatelessWidget {
  const FaceNotRecognizedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoModalCard(
      icon: const _FaceIcon(),
      title: 'Face Not Recognized',
      body: 'Enter Transfa Passcode to\ncontinue.',
      actions: [
        PillButton(label: 'Enter Passcode', onPressed: () => context.pop()),
        PillButton(label: 'Cancel', variant: PillVariant.secondary, onPressed: () => context.pop()),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// "Home / Get Power" — utility payment entry.
// ---------------------------------------------------------------------------
class GetPowerScreen extends StatelessWidget {
  const GetPowerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoModalCard(
      icon: const _PowerIcon(),
      title: 'Home',
      body: 'Use your meter location to\nget power and verify your\nhome.',
      actions: [
        PillButton(label: 'Get Power', variant: PillVariant.orange, onPressed: () => context.pop()),
        PillButton(label: 'Cancel', variant: PillVariant.secondary, onPressed: () => context.pop()),
      ],
    );
  }
}
