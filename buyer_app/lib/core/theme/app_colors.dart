import 'package:flutter/material.dart';

class AppColors {
  // ─── Primary Enterprise Palette ──────────────────────────────────
  static const Color primary = Color(0xFF1A56DB);
  static const Color primaryLight = Color(0xFF3F83F8);
  static const Color primaryDark = Color(0xFF1E40AF);
  static const Color primarySurface = Color(0xFFEBF5FF);
  static const Color secondary = Color(0xFF7C3AED);

  // Legacy aliases (backward compat for old screens)
  static const Color accent = Color(0xFF7C3AED);
  static const Color backgroundSecondary = Color(0xFFF1F5F9);

  // ─── Backgrounds ─────────────────────────────────────────────────
  static const Color background = Color(0xFFF8FAFC);
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color surfaceElevated = Color(0xFFFAFBFC);

  // ─── Text ────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnDark = Color(0xFFF8FAFC);

  // ─── Domain Accent Colors ────────────────────────────────────────
  static const Color domainAIML = Color(0xFF8B5CF6);
  static const Color domainCSE = Color(0xFF3B82F6);
  static const Color domainIOT = Color(0xFF10B981);
  static const Color domainDataScience = Color(0xFFF59E0B);
  static const Color domainEEE = Color(0xFFEF4444);
  static const Color domainECE = Color(0xFF06B6D4);
  static const Color domainMech = Color(0xFFF97316);
  static const Color domainCivil = Color(0xFF84CC16);

  // ─── Category Colors ─────────────────────────────────────────────
  static const Color categoryProjects = Color(0xFF1A56DB);
  static const Color categoryResume = Color(0xFF059669);
  static const Color categoryResumeWriting = Color(0xFF7C3AED);
  static const Color categoryResearchPaper = Color(0xFFDC2626);
  static const Color categoryFinalYear = Color(0xFFF59E0B);

  // ─── Functional ──────────────────────────────────────────────────
  static const Color success = Color(0xFF059669);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFDC2626);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF0284C7);
  static const Color infoLight = Color(0xFFE0F2FE);

  // ─── Borders & Dividers ──────────────────────────────────────────
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFF1F5F9);
  static const Color borderFocus = Color(0xFF3B82F6);

  // ─── Stars ───────────────────────────────────────────────────────
  static const Color starFilled = Color(0xFFFBBF24);
  static const Color starEmpty = Color(0xFFE2E8F0);

  // ─── Gradients ───────────────────────────────────────────────────
  static const Gradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1A56DB), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient heroGradient = LinearGradient(
    colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF334155)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient goldGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient emeraldGradient = LinearGradient(
    colors: [Color(0xFF059669), Color(0xFF0284C7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient purpleGradient = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFFEC4899)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ─── Shadows ─────────────────────────────────────────────────────
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> mediumShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> primaryShadow = [
    BoxShadow(
      color: primary.withOpacity(0.25),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  static Color shadow = Colors.black.withOpacity(0.05);
  static const Color shadowMedium = Color(0x14000000);

  // ─── Domain Color Helpers ────────────────────────────────────────
  static Color getDomainColor(String domain) {
    final d = domain.toUpperCase();
    if (d.contains('AI') || d.contains('ML') || d.contains('ARTIFICIAL') || d.contains('MACHINE LEARNING')) return domainAIML;
    if (d.contains('CSE') || d.contains('COMPUTER SCIENCE') || d.contains('SOFTWARE')) return domainCSE;
    if (d.contains('IOT') || d.contains('EMBEDDED') || d.contains('INTERNET')) return domainIOT;
    if (d.contains('DATA') || d.contains('ANALYTICS') || d.contains('BIG DATA')) return domainDataScience;
    if (d.contains('EEE') || d.contains('ELECTRICAL')) return domainEEE;
    if (d.contains('ECE') || d.contains('ELECTRONICS') || d.contains('COMMUNICATION')) return domainECE;
    if (d.contains('MECH') || d.contains('ROBOTICS')) return domainMech;
    if (d.contains('CIVIL') || d.contains('STRUCTURAL')) return domainCivil;
    if (d.contains('CYBER') || d.contains('SECURITY')) return error;
    if (d.contains('BLOCKCHAIN') || d.contains('WEB3')) return secondary;
    return primary;
  }
}
