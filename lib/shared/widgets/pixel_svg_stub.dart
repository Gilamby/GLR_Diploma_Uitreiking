import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PixelSvgPlatform extends StatelessWidget {
  const PixelSvgPlatform({
    required this.assetPath,
    required this.fit,
    super.key,
  });

  final String assetPath;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(assetPath, fit: fit);
  }
}

