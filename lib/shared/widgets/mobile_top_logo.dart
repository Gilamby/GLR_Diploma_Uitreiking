import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Design-space rect for the logo shown on all post-login screens.
/// Slightly larger than the original to match updated UI.
const mobileTopLogoRect = Rect.fromLTWH(522, 42, 318, 193);

class MobileTopLogo extends StatelessWidget {
  const MobileTopLogo({required this.scale, super.key});

  final double scale;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SvgPicture.asset(
        'assets/design/logo.svg',
        fit: BoxFit.contain,
      ),
    );
  }
}

