import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  static const String fontFamily = 'Inter';

  static const TextStyle displayLarge = TextStyle(fontFamily: fontFamily, fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -0.5, color: VC.text, height: 1.2);
  static const TextStyle displayMedium = TextStyle(fontFamily: fontFamily, fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: -0.3, color: VC.text, height: 1.25);
  static const TextStyle headingLarge = TextStyle(fontFamily: fontFamily, fontSize: 24, fontWeight: FontWeight.w600, letterSpacing: -0.2, color: VC.text, height: 1.3);
  static const TextStyle headingMedium = TextStyle(fontFamily: fontFamily, fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: -0.1, color: VC.text, height: 1.3);
  static const TextStyle headingSmall = TextStyle(fontFamily: fontFamily, fontSize: 18, fontWeight: FontWeight.w600, color: VC.text, height: 1.35);
  static const TextStyle subheadingLarge = TextStyle(fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.w600, color: VC.text, height: 1.4);
  static const TextStyle subheadingMedium = TextStyle(fontFamily: fontFamily, fontSize: 14, fontWeight: FontWeight.w600, color: VC.text, height: 1.4);
  static const TextStyle bodyLarge = TextStyle(fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.w400, color: VC.text, height: 1.5);
  static const TextStyle bodyMedium = TextStyle(fontFamily: fontFamily, fontSize: 14, fontWeight: FontWeight.w400, color: VC.textSec, height: 1.5);
  static const TextStyle bodySmall = TextStyle(fontFamily: fontFamily, fontSize: 12, fontWeight: FontWeight.w400, color: VC.textSec, height: 1.5);
  static const TextStyle caption = TextStyle(fontFamily: fontFamily, fontSize: 11, fontWeight: FontWeight.w400, color: VC.textTer, height: 1.4, letterSpacing: 0.2);
  static const TextStyle buttonLarge = TextStyle(fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.3, height: 1.2);
  static const TextStyle buttonMedium = TextStyle(fontFamily: fontFamily, fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.2, height: 1.2);
  static const TextStyle buttonSmall = TextStyle(fontFamily: fontFamily, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.2, height: 1.2);
  static const TextStyle label = TextStyle(fontFamily: fontFamily, fontSize: 12, fontWeight: FontWeight.w500, color: VC.textSec, letterSpacing: 0.5, height: 1.3);
  static const TextStyle priceLarge = TextStyle(fontFamily: fontFamily, fontSize: 24, fontWeight: FontWeight.w700, color: VC.accent, height: 1.2);
  static const TextStyle priceMedium = TextStyle(fontFamily: fontFamily, fontSize: 18, fontWeight: FontWeight.w700, color: VC.accent, height: 1.2);
  static const TextStyle priceSmall = TextStyle(fontFamily: fontFamily, fontSize: 14, fontWeight: FontWeight.w600, color: VC.accent, height: 1.2);
}
