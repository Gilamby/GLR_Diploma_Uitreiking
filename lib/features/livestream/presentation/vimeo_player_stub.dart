import 'package:flutter/material.dart';

import 'vimeo_player.dart';

class VimeoPlayerStub extends VimeoPlayerBase {
  const VimeoPlayerStub({required super.url, super.key});

  @override
  Widget build(BuildContext context) {
    // Non-web fallback.
    return Center(
      child: SelectableText(url),
    );
  }
}

// Alias used by conditional import.
typedef VimeoPlayerImpl = VimeoPlayerStub;

