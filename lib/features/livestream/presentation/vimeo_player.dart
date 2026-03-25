import 'package:flutter/material.dart';

import 'vimeo_player_stub.dart'
    if (dart.library.html) 'vimeo_player_web.dart';

class VimeoPlayer extends StatelessWidget {
  const VimeoPlayer({required this.url, super.key});

  final String url;

  @override
  Widget build(BuildContext context) {
    if (url.trim().isEmpty) return const SizedBox.shrink();
    return VimeoPlayerImpl(url: url);
  }
}

abstract class VimeoPlayerBase extends StatelessWidget {
  const VimeoPlayerBase({required this.url, super.key});
  final String url;
}

