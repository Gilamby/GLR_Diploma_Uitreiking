import 'package:flutter/material.dart';

/// Palette aligned with `assets/design/logo.svg` and `Mobile - Main.svg`
/// (neon `#8FE508`, background fade toward `#263E00`).
class DesignTokens {
  static const neon = Color(0xFF8FE508);
  static const neonSoft = Color(0xFF9EF020);
  static const black = Color(0xFF000000);
  static const dark = Color(0xFF0D0D0D);
  static const darkMuted = Color(0xFF263E00);
  static const gold = Color(0xFFBC9832);
  static const maroon = Color(0xFFA74D56);
  static const white = Color(0xFFFFFFFF);

  static const backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [black, darkMuted],
  );
}
