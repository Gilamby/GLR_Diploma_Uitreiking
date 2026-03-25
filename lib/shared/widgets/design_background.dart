import 'package:flutter/material.dart';

import '../../core/theme/design_tokens.dart';

/// Full-screen [logo.svg] was removed from the background: that asset embeds a
/// very large raster and made first paint slow on web.
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
