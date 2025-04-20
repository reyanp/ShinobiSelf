import 'package:flutter/material.dart';

/// App color palette updated for better accessibility and Duolingo-like UX
class AppColors {
  // Primary colors - updated for better accessibility and contrast
  static const Color chakraBlue = Color(0xFF1CB0F6); // Duolingo-like blue
  static const Color narutoOrange = Color(0xFFFF9600); // Better orange contrast
  static const Color sakuraPink = Color(0xFFFF4B4B); // More accessible red-pink
  static const Color sasukePurple =
      Color(0xFF7E57C2); // Softer purple for better readability
  static const Color leafGreen = Color(0xFF58CC02); // Duolingo-style green
  static const Color sharinganRed = Color(0xFFFF3A2B); // More vivid red
  static const Color chakraRed =
      Color(0xFFFF4B4B); // Consistent with sakuraPink
  static const Color chakraGreen =
      Color(0xFF58CC02); // Consistent with leafGreen
  static const Color silverGray =
      Color(0xFFAFB5BD); // Softer silver for better contrast

  // Secondary colors
  static const Color sakuraPink2 =
      Color(0xFFFFCCCC); // Lighter pink with better contrast

  // Functional colors - improved for accessibility
  static const Color background =
      Color(0xFFF7F7F7); // Slightly warmer background
  static const Color cardBackground = Colors.white;
  static const Color textPrimary =
      Color(0xFF333333); // Dark but not pure black for less eye strain
  static const Color textSecondary =
      Color(0xFF777777); // Better contrast than previous
  static const Color divider = Color(0xFFE5E5E5); // Softer divider

  // Status colors - adjusted for better visibility
  static const Color success = Color(0xFF58CC02); // Consistent with leafGreen
  static const Color error = Color(0xFFFF4B4B); // Consistent with sakuraPink
  static const Color warning = Color(0xFFFFC800); // Better visibility yellow
  static const Color info = chakraBlue;

  // Character path colors - consistent with primary colors
  static const Color narutoPathColor = narutoOrange;
  static const Color sasukePathColor = sasukePurple;
  static const Color sakuraPathColor = sakuraPink;

  // Rank colors - adjusted for better progression and visibility
  static const Color geninColor = Color(0xFF58CC02); // Green entry level
  static const Color chuninColor = Color(0xFF1CB0F6); // Blue mid level
  static const Color jouninColor = Color(0xFFAC52FF); // Purple high level
  static const Color hokageColor = Color(0xFFFF9600); // Orange master level
}
