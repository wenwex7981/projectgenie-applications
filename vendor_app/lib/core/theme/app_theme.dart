import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ─── Enterprise Vendor Color Palette ───────────────────────────
  static const Color primary = Color(0xFF0F172A);
  static const Color primaryLight = Color(0xFF1E293B);
  static const Color accent = Color(0xFF3B82F6);
  static const Color accentDark = Color(0xFF1D4ED8);
  static const Color accentSurface = Color(0xFFDBEAFE);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primary,
    scaffoldBackgroundColor: const Color(0xFFF8FAFC),
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      secondary: accent,
      surface: Colors.white,
      error: const Color(0xFFEF4444),
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme).copyWith(
      displayLarge: GoogleFonts.inter(fontSize: 34, fontWeight: FontWeight.w900, color: primary, letterSpacing: -1.2),
      displayMedium: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w800, color: primary, letterSpacing: -1),
      displaySmall: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w800, color: primary, letterSpacing: -0.5),
      headlineMedium: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: primary),
      titleLarge: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: primary),
      titleMedium: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: primary),
      bodyLarge: GoogleFonts.inter(fontSize: 16, color: const Color(0xFF334155)),
      bodyMedium: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF475569)),
      labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: accent),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: primary,
      elevation: 0,
      centerTitle: false,
      scrolledUnderElevation: 0.5,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: primary),
      iconTheme: const IconThemeData(color: primary),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF1F5F9),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: accent, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      hintStyle: GoogleFonts.inter(color: const Color(0xFF94A3B8), fontWeight: FontWeight.w500),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700),
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primary,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        side: BorderSide(color: accent.withOpacity(0.3)),
        textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: accent.withOpacity(0.1),
      surfaceTintColor: Colors.transparent,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w800, color: accent, letterSpacing: -0.3);
        }
        return GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w500, color: const Color(0xFF94A3B8), letterSpacing: -0.3);
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: accent, size: 22);
        }
        return const IconThemeData(color: Color(0xFF94A3B8), size: 22);
      }),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.white,
      selectedColor: accent.withOpacity(0.1),
      labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFE2E8F0),
      thickness: 1,
      space: 1,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}
