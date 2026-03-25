import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'design_tokens.dart';

ThemeData appTheme() {
  const primaryColor = DesignTokens.maroon;
  const accentColor = DesignTokens.gold;
  const backgroundColor = DesignTokens.black;

  final baseText = ThemeData(brightness: Brightness.dark).textTheme;
  final fredokaBase = GoogleFonts.fredokaTextTheme(baseText).apply(
    bodyColor: DesignTokens.white,
    displayColor: DesignTokens.neon,
  );

  TextStyle luckiestNeon() => GoogleFonts.luckiestGuy(color: DesignTokens.neon);

  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      secondary: accentColor,
      surface: backgroundColor,
    ),
    scaffoldBackgroundColor: backgroundColor,
    fontFamily: GoogleFonts.fredoka().fontFamily,
    textTheme: fredokaBase.copyWith(
      displayLarge: luckiestNeon(),
      displayMedium: luckiestNeon(),
      headlineLarge: luckiestNeon(),
      headlineMedium: luckiestNeon(),
      headlineSmall: luckiestNeon(),
      titleLarge: luckiestNeon(),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: DesignTokens.black.withValues(alpha: 0.55),
      labelStyle: GoogleFonts.fredoka(color: DesignTokens.neon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: DesignTokens.gold),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: DesignTokens.gold),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: DesignTokens.neon, width: 1.8),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: DesignTokens.maroon,
        foregroundColor: DesignTokens.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      foregroundColor: DesignTokens.neon,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: DesignTokens.black.withValues(alpha: 0.65),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: DesignTokens.gold, width: 1.2),
      ),
    ),
  );
}
