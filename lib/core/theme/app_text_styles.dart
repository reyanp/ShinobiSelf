import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Text styles for the Shinobi Self app
class AppTextStyles {
  // Headings
  static TextStyle get heading1 => GoogleFonts.nunito(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      );

  static TextStyle get heading2 => GoogleFonts.nunito(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle get heading3 => GoogleFonts.nunito(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  // Body text
  static TextStyle get bodyLarge => GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyMedium => GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodySmall => GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  // Button text
  static TextStyle get buttonLarge => GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );

  static TextStyle get buttonMedium => GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );

  // Special styles
  static TextStyle get ninjaRank => GoogleFonts.nunito(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
        color: AppColors.chakraBlue,
      );

  static TextStyle get questTitle => GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get questDescription => GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.4,
      );

  static TextStyle get xpCounter => GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.chakraBlue,
      );

  static TextStyle get streakCounter => GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.narutoOrange,
      );

  // Character path specific styles
  static TextStyle narutoStyle(TextStyle baseStyle) => baseStyle.copyWith(
        color: AppColors.narutoOrange,
      );

  static TextStyle sasukeStyle(TextStyle baseStyle) => baseStyle.copyWith(
        color: AppColors.sasukePurple,
      );

  static TextStyle sakuraStyle(TextStyle baseStyle) => baseStyle.copyWith(
        color: AppColors.sakuraPink,
      );

  // Dark mode variants with improved visibility
  // These should be used in dark mode contexts to ensure text is visible
  static TextStyle darkModeTextSecondary = GoogleFonts.nunito(
    fontSize: 14,
    fontWeight: FontWeight.w500, // Slightly bolder for better visibility
    color:
        Colors.white, // Use pure white instead of opacity for better visibility
  );

  /// Converts a regular text style to a dark mode friendly version
  static TextStyle toDarkMode(TextStyle style) {
    final Color textColor = style.color ?? AppColors.textPrimary;

    // If color is already bright (like primary colors), keep it
    if (textColor == AppColors.chakraBlue ||
        textColor == AppColors.narutoOrange ||
        textColor == AppColors.sakuraPink ||
        textColor == AppColors.sasukePurple ||
        textColor == AppColors.leafGreen) {
      return style;
    }

    // If it's a greyish color, make it white for dark mode
    if (textColor == AppColors.textSecondary ||
        textColor == AppColors.silverGray) {
      return style.copyWith(
        color: Colors.white, // Use pure white for maximum visibility
        fontWeight: FontWeight.lerp(style.fontWeight, FontWeight.w500, 0.3),
      );
    }

    // For other colors, ensure they're white in dark mode
    return style.copyWith(
      color: Colors.white,
    );
  }
}
