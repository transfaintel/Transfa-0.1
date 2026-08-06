import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/assets.dart';

class HomeFab extends StatelessWidget {
  final VoidCallback onTap;
  final double size;

  const HomeFab({super.key, required this.onTap, this.size = 60});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        child: SvgPicture.asset(
          Assets.sweetHome,
          width: size,
          height: size,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class Add extends StatelessWidget {
  final VoidCallback onTap;
  final double size;

  const Add({super.key, required this.onTap, this.size = 60});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        child: SvgPicture.asset(
          Assets.addRed,
          width: size,
          height: size,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
