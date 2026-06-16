import 'package:flutter/material.dart';

import 'transfa_ai_screen.dart';

/// Thin wrapper that lands on the keypad half of the merged
/// [TransfaAiScreen]. Kept so `Routes.amount` (and any pushes from the
/// dashboard / dev menu) still resolve to a familiar entry point while
/// the actual UI lives in one combined screen.
class AmountKeypadScreen extends StatelessWidget {
  const AmountKeypadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TransfaAiScreen(initialView: TransfaAiView.keypad);
  }
}
