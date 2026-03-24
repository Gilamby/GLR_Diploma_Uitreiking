import 'package:flutter/material.dart';

class DesignTokens {
  static const neon = Color(0xFF89E000); // TODO: CLIENT CONFIG
  static const neonSoft = Color(0xFF9BF000); // TODO: CLIENT CONFIG
  static const black = Color(0xFF000000); // TODO: CLIENT CONFIG
  static const dark = Color(0xFF111111); // TODO: CLIENT CONFIG
  static const darkMuted = Color(0xFF1E1E1E); // TODO: CLIENT CONFIG
  static const gold = Color(0xFFBC9832); // TODO: CLIENT CONFIG
  static const maroon = Color(0xFFA74D56); // TODO: CLIENT CONFIG
  static const white = Color(0xFFFFFFFF); // TODO: CLIENT CONFIG

  static const backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [dark, darkMuted, black],
  ); // TODO: CLIENT CONFIG
}
