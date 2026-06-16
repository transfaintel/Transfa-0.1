import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/assets.dart';

/// Full-bleed scaffold used by Home, Wallet, Passcode — the lock-screen
/// style surfaces that take over the whole viewport with the wallpaper
/// photo behind.
class WallpaperScaffold extends StatelessWidget {
  final Widget body;
  final bool blur;
  final double darken;
  final String? wallpaper;

  const WallpaperScaffold({
    super.key,
    required this.body,
    this.blur = false,
    this.darken = 0.45,
    this.wallpaper,
  });

  @override
  Widget build(BuildContext context) {
    final asset = wallpaper ?? Assets.wallpaper;
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(asset, fit: BoxFit.cover),
            if (blur)
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                child: Container(color: Colors.black.withValues(alpha: darken)),
              )
            else
              Container(color: Colors.black.withValues(alpha: darken)),
            SafeArea(child: body),
          ],
        ),
      ),
    );
  }
}
