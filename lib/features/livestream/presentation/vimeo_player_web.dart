// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;
import 'dart:ui_web' as ui;

import 'package:flutter/material.dart';

import 'vimeo_player.dart';

class VimeoPlayerWeb extends VimeoPlayerBase {
  VimeoPlayerWeb({required super.url, super.key})
      : _viewType = 'vimeo-player-${url.hashCode}';

  final String _viewType;

  @override
  Widget build(BuildContext context) {
    // Register once per unique url.
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      final iframe = html.IFrameElement()
        ..src = url
        ..style.border = '0'
        ..style.width = '100%'
        ..style.height = '100%'
        ..allowFullscreen = true;

      // Some browsers need explicit allow features.
      iframe.allow =
          'autoplay; fullscreen; picture-in-picture; encrypted-media; clipboard-write';

      return iframe;
    });

    return HtmlElementView(viewType: _viewType);
  }
}

// Alias used by conditional import.
typedef VimeoPlayerImpl = VimeoPlayerWeb;

