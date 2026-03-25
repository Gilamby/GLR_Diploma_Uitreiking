import 'package:flutter/material.dart';

import '../../core/theme/design_tokens.dart';

class DesignBackground extends StatelessWidget {
  const DesignBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(decoration: const BoxDecoration(gradient: DesignTokens.backgroundGradient)),
        child,
      ],
    );
  }
}
