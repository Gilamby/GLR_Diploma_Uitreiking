// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

class PixelSvgPlatform extends StatefulWidget {
  const PixelSvgPlatform({
    required this.assetPath,
    required this.fit,
    super.key,
  });

  final String assetPath;
  final BoxFit fit;

  @override
  State<PixelSvgPlatform> createState() => _PixelSvgPlatformState();
}

class _PixelSvgPlatformState extends State<PixelSvgPlatform> {
  late final String _viewType;

  @override
  void initState() {
    super.initState();
    _viewType = 'pixel-svg:${widget.assetPath}:${widget.fit.name}:${identityHashCode(this)}';

    // Flutter serves asset `foo/bar.svg` under `assets/foo/bar.svg` on web.
    final src = Uri.encodeFull('assets/${widget.assetPath}');

    // Register view factory once for this instance.
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      final img = html.ImageElement()
        ..src = src
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.objectFit = _objectFitCss(widget.fit)
        ..style.objectPosition = 'center center'
        ..draggable = false;
      return img;
    });
  }

  String _objectFitCss(BoxFit fit) {
    return switch (fit) {
      BoxFit.fill => 'fill',
      BoxFit.contain => 'contain',
      BoxFit.cover => 'cover',
      BoxFit.fitWidth => 'contain',
      BoxFit.fitHeight => 'contain',
      BoxFit.none => 'none',
      BoxFit.scaleDown => 'scale-down',
    };
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: _viewType);
  }
}

