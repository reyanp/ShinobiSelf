import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// Theme configuration for the Shinobi Self app
class AppTheme {
  // Light theme - Now a static method accepting accentColor
  static ThemeData lightTheme(Color accentColor) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: accentColor, // Use dynamic accent color
        secondary: accentColor, // Or choose a different secondary logic
        tertiary: AppColors.sakuraPink,
        background: AppColors.background,
        surface: AppColors.cardBackground,
        error: AppColors.error,
        onPrimary: Colors.white, // Adjust if accent is light
        onSecondary: Colors.white, // Adjust if accent is light
        onSurface: AppColors.textPrimary,
        onBackground: AppColors.textPrimary,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.cardBackground, // Lighter AppBar
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.cardBackground,
        elevation: 1, // Subtle elevation
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.white, // Adjust if accent is light
          elevation: 1,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accentColor,
          side: BorderSide(color: accentColor, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentColor,
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: accentColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.error, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: GoogleFonts.nunito(
          fontSize: 16,
          color: AppColors.textSecondary.withOpacity(0.6),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: accentColor,
        linearTrackColor: AppColors.divider,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimary, // Consider dark grey
        contentTextStyle: GoogleFonts.nunito(
          fontSize: 16,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: accentColor,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: GoogleFonts.nunito(
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: GoogleFonts.nunito(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      textTheme: GoogleFonts.nunitoTextTheme(),
       // Include themes from previous version if needed
       segmentedButtonTheme: SegmentedButtonThemeData(
         style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
             if (states.contains(MaterialState.selected)) {
                return accentColor.withOpacity(0.2);
              }
              return AppColors.background; // Use light background
            }),
            foregroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
             if (states.contains(MaterialState.selected)) {
                return accentColor;
              }
              return AppColors.textSecondary;
            }),
           side: MaterialStateProperty.all(BorderSide(color: AppColors.divider)),
         ),
       ),
       switchTheme: SwitchThemeData(
         thumbColor: MaterialStateProperty.resolveWith<Color?>((states) {
           if (states.contains(MaterialState.selected)) {
             return accentColor;
           }
           return null; // Defaults
         }),
         trackColor: MaterialStateProperty.resolveWith<Color?>((states) {
            if (states.contains(MaterialState.selected)) {
             return accentColor.withOpacity(0.5);
           }
           return null; // Defaults
         }),
       ),
        chipTheme: ChipThemeData(
         backgroundColor: AppColors.background,
         selectedColor: accentColor.withOpacity(0.2),
         labelStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
         secondaryLabelStyle: AppTextStyles.bodySmall.copyWith(color: accentColor, fontWeight: FontWeight.bold),
         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
         shape: StadiumBorder(side: BorderSide(color: AppColors.divider)),
       ),
    );
  }

  // Dark theme - Now a static method accepting accentColor
  static ThemeData darkTheme(Color accentColor) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: accentColor,
        secondary: accentColor, // Or choose a different secondary logic
        tertiary: AppColors.sakuraPink, // Adjust if needed
        background: const Color(0xFF121212),
        surface: const Color(0xFF1E1E1E),
        error: AppColors.error, // Consider a slightly lighter red for dark mode
        onPrimary: Colors.black, // Adjust based on accent brightness
        onSecondary: Colors.black, // Adjust based on accent brightness
        onSurface: Colors.white.withOpacity(0.87),
        onBackground: Colors.white.withOpacity(0.87),
        onError: Colors.black,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white.withOpacity(0.87),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white.withOpacity(0.87),
        ),
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF1E1E1E),
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.black, // Adjust based on accent brightness
          elevation: 1,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
       outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accentColor,
          side: BorderSide(color: accentColor, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
       textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentColor,
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.12)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.12)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: accentColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.error, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: GoogleFonts.nunito(
          fontSize: 16,
          color: Colors.white.withOpacity(0.6),
        ),
      ),
       dividerTheme: DividerThemeData(
        color: Colors.white.withOpacity(0.12),
        thickness: 1,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: accentColor,
        linearTrackColor: Colors.white.withOpacity(0.12),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF333333), // Darker grey
        contentTextStyle: GoogleFonts.nunito(
          fontSize: 16,
          color: Colors.white.withOpacity(0.87),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),
       bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFF1E1E1E),
        selectedItemColor: accentColor,
        unselectedItemColor: Colors.white.withOpacity(0.6),
        selectedLabelStyle: GoogleFonts.nunito(
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: GoogleFonts.nunito(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      textTheme: GoogleFonts.nunitoTextTheme(ThemeData.dark().textTheme),
       // Include themes from previous version if needed
       segmentedButtonTheme: SegmentedButtonThemeData(
         style: ButtonStyle(
           backgroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
             if (states.contains(MaterialState.selected)) {
                return accentColor.withOpacity(0.3);
              }
              return const Color(0xFF1E1E1E); // Use dark surface
            }),
           foregroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
             if (states.contains(MaterialState.selected)) {
                return accentColor;
              }
              return Colors.white.withOpacity(0.6);
            }),
           side: MaterialStateProperty.all(BorderSide(color: Colors.white.withOpacity(0.12))),
         ),
       ),
        switchTheme: SwitchThemeData(
         thumbColor: MaterialStateProperty.resolveWith<Color?>((states) {
           if (states.contains(MaterialState.selected)) {
             return accentColor;
           }
           return null; // Defaults
         }),
         trackColor: MaterialStateProperty.resolveWith<Color?>((states) {
            if (states.contains(MaterialState.selected)) {
             return accentColor.withOpacity(0.5);
           }
           return null; // Defaults
         }),
       ),
       chipTheme: ChipThemeData(
         backgroundColor: const Color(0xFF1E1E1E),
         selectedColor: accentColor.withOpacity(0.3),
         labelStyle: AppTextStyles.bodySmall.copyWith(color: Colors.white.withOpacity(0.6)),
         secondaryLabelStyle: AppTextStyles.bodySmall.copyWith(color: accentColor, fontWeight: FontWeight.bold),
         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
         shape: StadiumBorder(side: BorderSide(color: Colors.white.withOpacity(0.12))),
       ),
    );
  }

  // Character-specific themes
  static ThemeData narutoTheme(Color accentColor) {
    return lightTheme(accentColor).copyWith(
      // Keep light theme but override primary/secondary for Naruto
      colorScheme: lightTheme(accentColor).colorScheme.copyWith(
        primary: AppColors.narutoOrange,
        secondary: AppColors.chakraBlue, // Keep blue as secondary for contrast
      ),
       // Optionally override other specific naruto elements here
    );
  }

  static ThemeData sasukeTheme(Color accentColor) {
     // Use dark theme as a base for Sasuke
    return darkTheme(accentColor).copyWith(
      colorScheme: darkTheme(accentColor).colorScheme.copyWith(
        primary: AppColors.sasukePurple,
        secondary: AppColors.sharinganRed, // Use a distinct secondary
      ),
       // Optionally override other specific sasuke elements here
    );
  }

  static ThemeData sakuraTheme(Color accentColor) {
    return lightTheme(accentColor).copyWith(
      colorScheme: lightTheme(accentColor).colorScheme.copyWith(
        primary: AppColors.sakuraPink,
        secondary: AppColors.leafGreen,
      ),
       // Optionally override other specific sakura elements here
    );
  }
}
