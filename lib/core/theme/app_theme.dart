import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0A0A0A) : const Color(0xFFF9FAFB);
    final surfaceColor = isDark ? const Color(0xFF171717) : const Color(0xFFFFFFFF);
    final accentColor = const Color(0xFF6366F1); // Indigo Primary

    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: bgColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: accentColor,
        brightness: brightness,
        surface: surfaceColor,
      ),
      useMaterial3: true,
      textTheme: GoogleFonts.outfitTextTheme(
        ThemeData(brightness: brightness).textTheme,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceColor.withOpacity(0.8),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: brightness,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: isDark ? 0 : 2,
        shadowColor: Colors.black.withOpacity(0.04),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: isDark ? const BorderSide(color: Colors.white10, width: 1) : BorderSide.none,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: isDark ? Colors.white10 : Colors.black12,
        space: 1,
      ),
    );
  }
}
