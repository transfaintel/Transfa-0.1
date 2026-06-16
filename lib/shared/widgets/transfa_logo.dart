import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/assets.dart';

/// The chromatic-aberration "t" logo (cyan-left / red-right / black).
/// Backed by the Transfa Startup SVG so the brand mark is pixel-exact.
class TransfaLogo extends StatelessWidget {
  final double size;
  const TransfaLogo({super.key, this.size = 120});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      Assets.logoChromatic,
      height: size,
      fit: BoxFit.contain,
    );
  }
}

/// The compact "t" used inside buttons and headers.
class TransfaMark extends StatelessWidget {
  final double size;
  final bool white;
  const TransfaMark({super.key, this.size = 24, this.white = false});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      white ? Assets.logoSmallWhite: Assets.logoChromatic ,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
