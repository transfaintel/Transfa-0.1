import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'dart:io';

// Provider for connectivity state
final connectivityProvider = StateNotifierProvider<ConnectivityNotifier, ConnectivityState>((ref) {
  return ConnectivityNotifier();
});

// Provider to check if popup is showing
final isNoInternetPopupShowingProvider = StateProvider<bool>((ref) => false);

class ConnectivityState {
  final bool isConnected;
  final bool hasShownPopup;

  const ConnectivityState({
    this.isConnected = true,
    this.hasShownPopup = false,
  });

  ConnectivityState copyWith({
    bool? isConnected,
    bool? hasShownPopup,
  }) {
    return ConnectivityState(
      isConnected: isConnected ?? this.isConnected,
      hasShownPopup: hasShownPopup ?? this.hasShownPopup,
    );
  }
}

class ConnectivityNotifier extends StateNotifier<ConnectivityState> {
  StreamSubscription? _subscription;
  Timer? _recheckTimer;
  bool _isInitialized = false;

  ConnectivityNotifier() : super(const ConnectivityState()) {
    _initConnectivity();
  }

  void _initConnectivity() {
    if (_isInitialized) return;
    _isInitialized = true;
    
    // Check connectivity every 5 seconds
    _subscription = Stream.periodic(const Duration(seconds: 5))
        .listen((_) {
      _checkConnectivity();
    });
    
    // Immediate check
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    try {
      // Simple connectivity check - try to reach a reliable host
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 3));
      
      final isConnected = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      
      if (state.isConnected != isConnected) {
        state = state.copyWith(isConnected: isConnected);
        
        if (!isConnected) {
          // Reset popup shown flag when connection is lost
          state = state.copyWith(hasShownPopup: false);
        } else {
          // Recheck after connection is restored
          _recheckTimer?.cancel();
          _recheckTimer = Timer(const Duration(seconds: 2), () {
            state = state.copyWith(hasShownPopup: false);
          });
        }
      }
    } catch (e) {
      // Connection failed
      if (state.isConnected) {
        state = state.copyWith(isConnected: false, hasShownPopup: false);
      }
    }
  }

  void popupShown() {
    state = state.copyWith(hasShownPopup: true);
  }

  void resetPopupShown() {
    state = state.copyWith(hasShownPopup: false);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _recheckTimer?.cancel();
    super.dispose();
  }
}