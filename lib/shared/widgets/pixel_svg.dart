import 'package:flutter/widgets.dart';

import 'pixel_svg_stub.dart'
    if (dart.library.html) 'pixel_svg_web.dart';

/// Renders an SVG using the best available renderer for the platform.
///
/// - On **web**, uses a real browser `<img>` so SVG filters (blur/glow) match
///   Figma exports much more closely than `flutter_svg`.
/// - On other platforms, falls back to `flutter_svg`.
class PixelSvg extends StatelessWidget {
  const PixelSvg({
    required this.assetPath,
    this.fit = BoxFit.contain,
    super.key,
  });

  final String assetPath;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return PixelSvgPlatform(assetPath: assetPath, fit: fit);
  }
}

