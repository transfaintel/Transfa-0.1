// lib/features/pop-ups/no_internet_popup.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/assets.dart';

// lib/features/pop-ups/no_internet_popup.dart - Make sure onClose is used
class NoInternetPopup extends StatefulWidget {
  final VoidCallback? onClose;
  
  const NoInternetPopup({super.key, this.onClose});

  @override
  State<NoInternetPopup> createState() => _NoInternetPopupState();
}


class _NoInternetPopupState extends State<NoInternetPopup>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Close the popup with exit animation
  Future<void> closeWithAnimation() async {
    await _animationController.reverse();
    if (mounted) {
      widget.onClose?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          await closeWithAnimation();
        }
      },
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: GestureDetector(
            onTap: () {},
            child: SlideTransition(
              position: _slideAnimation,
              child: _NoInternetPopupContent(onClose: closeWithAnimation),
            ),
          ),
        ),
      ),
    );
  }
}

class _NoInternetPopupContent extends StatelessWidget {
  final VoidCallback onClose;

  const _NoInternetPopupContent({required this.onClose});

  /// Opens the Wi-Fi settings on the device
  void _openWifiSettings(BuildContext context) async {
    const platform = MethodChannel('app.settings/wifi');
    try {
      await platform.invokeMethod('openWifiSettings');
      onClose();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please open Wi-Fi settings from your device settings'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  /// Opens the Cellular/Mobile data settings on the device
  void _openCellularSettings(BuildContext context) async {
    const platform = MethodChannel('app.settings/cellular');
    try {
      await platform.invokeMethod('openCellularSettings');
      onClose();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please open Cellular settings from your device settings'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 270,
      height: 418,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFCFB).withOpacity(0.5),
        borderRadius: BorderRadius.circular(45),
      ),
      child: Column(
        children: [
          // Header Card
          Container(
            width: 246,
            height: 184,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
            child: Column(
              children: [
                // Network Unavailable Icon
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                  width: 60,
                  height: 60,
                  child: SvgPicture.asset(Assets.networkUnavailable),
                )),
                const SizedBox(height: 12),
                // Storyline Text
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'No Internet',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        height: 1.5,
                        letterSpacing: 0.02,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Connect to a Wi-Fi network or cellular data to continue.',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        fontSize: 17,
                        height: 1.5,
                        letterSpacing: 0.02,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Options Card
          Container(
            width: 246,
            height: 198,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
            child: Column(
              children: [
                // Wi-Fi Settings Button
                GestureDetector(
                  onTap: () => _openWifiSettings(context),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: const Center(
                      child: Text(
                        'Wi-Fi Settings',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                          height: 1.5,
                          letterSpacing: 0.02,
                          color: Color(0xFFFCFCFB),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Cellular Settings Button
                GestureDetector(
                  onTap: () => _openCellularSettings(context),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: const Center(
                      child: Text(
                        'Cellular Settings',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                          height: 1.5,
                          letterSpacing: 0.02,
                          color: Color(0xFFFCFCFB),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Cancel Button
                GestureDetector(
                  onTap: onClose,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFFF4466), Color(0xFFF41E42)],
                      ),
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: const Center(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                          height: 1.5,
                          letterSpacing: 0.02,
                          color: Color(0xFFFCFCFB),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Overlay method to show popup without Navigator dependency
OverlayEntry? _currentOverlayEntry;

void showNoInternetPopupOverlay(BuildContext context, OverlayState overlayState) {
  // Remove existing overlay if any
  _currentOverlayEntry?.remove();
  
  _currentOverlayEntry = OverlayEntry(
    builder: (context) => Material(
      color: Colors.black.withOpacity(0.4),
      child: Center(
        child: NoInternetPopup(
          onClose: () {
            _currentOverlayEntry?.remove();
            _currentOverlayEntry = null;
          },
        ),
      ),
    ),
  );
  
  overlayState.insert(_currentOverlayEntry!);
}

void hideNoInternetPopupOverlay() {
  _currentOverlayEntry?.remove();
  _currentOverlayEntry = null;
}