// lib/shared/widgets/connectivity_observer.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/pop-ups/no_internet_popup.dart';
import '../../providers/connectivity_provider.dart';

/// Widget that monitors connectivity and shows the no internet popup when needed
class ConnectivityObserver extends ConsumerWidget {
  final Widget child;

  const ConnectivityObserver({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityState = ref.watch(connectivityProvider);
    final hasShownPopup = ref.watch(isNoInternetPopupShowingProvider);

    // Only show popup if not connected AND popup hasn't been shown yet
    if (!connectivityState.isConnected && !hasShownPopup) {
      // Schedule the state update after build is complete using microtask
      Future.microtask(() {
        ref.read(isNoInternetPopupShowingProvider.notifier).state = true;
      });

      return Stack(
        children: [
          child,
          // Dark background overlay with gesture detector to prevent interaction
          GestureDetector(
            onTap: () {}, // Prevents taps from going through
            behavior: HitTestBehavior.opaque,
            child: Container(color: Colors.black.withOpacity(0.7)),
          ),
          // Centered popup
          Center(
            child: NoInternetPopup(
              onClose: () {
                // When popup is closed, reset the popup shown state
                ref.read(isNoInternetPopupShowingProvider.notifier).state =
                    false;
                debugPrint('Popup closed by user');
              },
            ),
          ),
        ],
      );
    }

    return child;
  }
}
