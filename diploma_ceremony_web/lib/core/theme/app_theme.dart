import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'design_tokens.dart';

ThemeData appTheme() {
  const primaryColor = DesignTokens.maroon; // TODO: CLIENT CONFIG
  const accentColor = DesignTokens.gold; // TODO: CLIENT CONFIG
  const backgroundColor = DesignTokens.black; // TODO: CLIENT CONFIG
  const fontFamily = 'Fredoka'; // TODO: CLIENT CONFIG

  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      secondary: accentColor,
      surface: backgroundColor,
    ),
    scaffoldBackgroundColor: backgroundColor,
    fontFamily: fontFamily,
    textTheme: TextTheme(
      displayLarge: GoogleFonts.luckiestGuy(color: DesignTokens.neon), // TODO: CLIENT CONFIG
      displayMedium: GoogleFonts.luckiestGuy(color: DesignTokens.neon), // TODO: CLIENT CONFIG
      headlineLarge: GoogleFonts.luckiestGuy(color: DesignTokens.neon), // TODO: CLIENT CONFIG
      headlineMedium: GoogleFonts.luckiestGuy(color: DesignTokens.neon), // TODO: CLIENT CONFIG
      headlineSmall: GoogleFonts.luckiestGuy(color: DesignTokens.neon), // TODO: CLIENT CONFIG
      titleLarge: GoogleFonts.luckiestGuy(color: DesignTokens.neon), // TODO: CLIENT CONFIG
      bodyLarge: GoogleFonts.fredoka(color: DesignTokens.white), // TODO: CLIENT CONFIG
      bodyMedium: GoogleFonts.fredoka(color: DesignTokens.white), // TODO: CLIENT CONFIG
      bodySmall: GoogleFonts.fredoka(color: DesignTokens.white), // TODO: CLIENT CONFIG
      labelLarge: GoogleFonts.fredoka(color: DesignTokens.white), // TODO: CLIENT CONFIG
      labelMedium: GoogleFonts.fredoka(color: DesignTokens.white), // TODO: CLIENT CONFIG
      labelSmall: GoogleFonts.fredoka(color: DesignTokens.white), // TODO: CLIENT CONFIG
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: DesignTokens.black.withOpacity(0.55),
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
      color: DesignTokens.black.withOpacity(0.65),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: DesignTokens.gold, width: 1.2),
      ),
    ),
  );
}
