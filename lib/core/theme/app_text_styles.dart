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
        color: AppColors.narutoPathColor,
      );

  static TextStyle sasukeStyle(TextStyle baseStyle) => baseStyle.copyWith(
        color: AppColors.sasukePathColor,
      );

  static TextStyle sakuraStyle(TextStyle baseStyle) => baseStyle.copyWith(
        color: AppColors.sakuraPathColor,
      );
}
