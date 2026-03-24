import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/theme/design_tokens.dart';

class DesignBackground extends StatelessWidget {
  const DesignBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(decoration: const BoxDecoration(gradient: DesignTokens.backgroundGradient)),
        Positioned.fill(
          child: Opacity(
            opacity: 0.08,
            child: SvgPicture.asset(
              'assets/design/logo.svg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        child,
      ],
    );
  }
}
