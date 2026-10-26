import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Stitch Design System Typography for CardSaathi
abstract final class AppTypography {
  // Headlines: Noto Serif (Devanagari matra cushion enabled)
  static TextStyle headlineLarge({Color color = AppColors.textPrimary}) =>
      GoogleFonts.notoSerif(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        height: 34 / 26,
        color: color,
      );

  static TextStyle headlineMedium({Color color = AppColors.textPrimary}) =>
      GoogleFonts.notoSerif(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 28 / 20,
        color: color,
      );

  static TextStyle headlineSmall({Color color = AppColors.textPrimary}) =>
      GoogleFonts.notoSerif(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 24 / 18,
        color: color,
      );

  // Titles: Plus Jakarta Sans
  static TextStyle titleMedium({Color color = AppColors.textPrimary}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        height: 22 / 16,
        color: color,
      );

  // Body: Plus Jakarta Sans
  static TextStyle bodyLarge({Color color = AppColors.textPrimary}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        height: 22 / 15,
        color: color,
      );

  static TextStyle bodyMedium({Color color = AppColors.textSecondary}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 18 / 13,
        color: color,
      );

  static TextStyle bodySmall({Color color = AppColors.textSecondary}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 16 / 12,
        color: color,
      );

  // Labels: Plus Jakarta Sans
  static TextStyle labelLarge({Color color = AppColors.textPrimary}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 20 / 14,
        color: color,
      );

  static TextStyle labelMedium({Color color = AppColors.textSecondary}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 16 / 12,
        color: color,
      );

  static TextStyle labelSmall({Color color = AppColors.textSecondary}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 14 / 11,
        color: color,
      );

  /// Assembled TextTheme for MaterialApp theme
  static TextTheme get textTheme => TextTheme(
    headlineLarge: headlineLarge(),
    headlineMedium: headlineMedium(),
    headlineSmall: headlineSmall(),
    titleMedium: titleMedium(),
    bodyLarge: bodyLarge(),
    bodyMedium: bodyMedium(),
    bodySmall: bodySmall(),
    labelLarge: labelLarge(),
    labelMedium: labelMedium(),
    labelSmall: labelSmall(),
  );
}
