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
    
    // Simply return the child with an overlay when no internet
    if (!connectivityState.isConnected) {
      return Stack(
        children: [
          child,
          // Dark background overlay
          Container(
            color: Colors.black.withOpacity(0.7),
          ),
          // Centered popup
          Center(
            child: NoInternetPopup(
              onClose: () {
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