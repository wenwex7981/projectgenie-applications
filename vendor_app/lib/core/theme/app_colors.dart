import 'package:flutter/material.dart';

/// Vendor Color System — Enterprise Design Tokens
class VC {
  // ─── Brand / Primary ──────────────────────────────────────────────
  static const Color primary = Color(0xFF0F172A);
  static const Color primaryLight = Color(0xFF1E293B);
  static const Color accent = Color(0xFF3B82F6);
  static const Color accentDark = Color(0xFF1D4ED8);
  static const Color accentLight = Color(0xFFDBEAFE);

  // ─── Backgrounds ─────────────────────────────────────────────────
  static const Color bg = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFF1F5F9);
  static const Color surfaceElevated = Color(0xFFFAFBFC);

  // ─── Text ────────────────────────────────────────────────────────
  static const Color text = Color(0xFF0F172A);
  static const Color textSec = Color(0xFF475569);
  static const Color textTer = Color(0xFF94A3B8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ─── Borders ─────────────────────────────────────────────────────
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFF1F5F9);
  static const Color borderFocus = Color(0xFF3B82F6);

  // ─── Functional Colors ───────────────────────────────────────────
  static const Color success = Color(0xFF22C55E);
  static const Color successBg = Color(0xFFF0FDF4);
  static const Color successDark = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningBg = Color(0xFFFEF3C7);
  static const Color warningDark = Color(0xFFD97706);
  static const Color error = Color(0xFFEF4444);
  static const Color errorBg = Color(0xFFFEF2F2);
  static const Color errorDark = Color(0xFFDC2626);
  static const Color info = Color(0xFF0EA5E9);
  static const Color infoBg = Color(0xFFF0F9FF);
  static const Color purple = Color(0xFF8B5CF6);
  static const Color purpleBg = Color(0xFFF5F3FF);
  static const Color gold = Color(0xFFFBBF24);
  static const Color goldBg = Color(0xFFFFFBEB);

  // ─── Gradients ───────────────────────────────────────────────────
  static const Gradient heroGrad = LinearGradient(
    colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF334155)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );

  static const Gradient accentGrad = LinearGradient(
    colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );

  static const Gradient successGrad = LinearGradient(
    colors: [Color(0xFF22C55E), Color(0xFF0EA5E9)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );

  static const Gradient goldGrad = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );

  static const Gradient purpleGrad = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );

  // ─── Shadows ─────────────────────────────────────────────────────
  static List<BoxShadow> softShadow = [
    BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4)),
  ];

  static List<BoxShadow> medShadow = [
    BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, 8)),
  ];

  static List<BoxShadow> accentShadow = [
    BoxShadow(color: accent.withValues(alpha: 0.25), blurRadius: 16, offset: const Offset(0, 6)),
  ];

  static List<BoxShadow> primaryShadow = [
    BoxShadow(color: primary.withValues(alpha: 0.15), blurRadius: 20, offset: const Offset(0, 8)),
  ];
}

/// Backward-compatible alias for widgets that use AppColors
class AppColors {
  static const Color accent = VC.accent;
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textPrimary = VC.text;
  static const Color textSecondary = VC.textSec;
  static const Color textTertiary = VC.textTer;
  static const Color border = VC.border;
  static const Color surface = VC.surface;
  static const Color surfaceVariant = VC.surfaceAlt;
  static const Color starFilled = Color(0xFFFBBF24);
  static const Color starEmpty = Color(0xFFE2E8F0);
  static const Color primary = VC.primary;
  static const Color primarySurface = VC.accentLight;
  static const Color success = VC.success;
  static const Color error = VC.error;
  static const Color warning = VC.warning;
  static const Color background = VC.bg;
}
