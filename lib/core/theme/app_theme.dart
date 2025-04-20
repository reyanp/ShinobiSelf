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
          fontSize: 22, // Slightly larger title
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.cardBackground,
        elevation: 2, // Slightly more elevation for depth
        shadowColor: Colors.black.withOpacity(0.1), // Softer shadow
        margin: const EdgeInsets.symmetric(
            vertical: 8, horizontal: 16), // Add margin for better spacing
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(20), // More rounded corners like Duolingo
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.white, // Adjust if accent is light
          elevation: 2, // More pronounced buttons
          shadowColor: accentColor.withOpacity(0.4), // Colored shadow for depth
          padding: const EdgeInsets.symmetric(
              horizontal: 24, vertical: 16), // More comfortable padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // More rounded corners
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: 18, // Larger text
            fontWeight: FontWeight.w700, // Bolder text like Duolingo
            letterSpacing: 0.5, // Slightly increased letter spacing
          ),
          minimumSize: const Size(88, 48), // Ensure buttons have minimum height
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accentColor,
          side: BorderSide(color: accentColor, width: 2), // Thicker border
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(16), // Match elevated button radius
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
          minimumSize: const Size(88, 48), // Ensure buttons have minimum height
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentColor,
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w700, // Bolder for better visibility
          ),
          padding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 8), // More padding
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16), // More rounded
          borderSide: BorderSide(
              color: AppColors.divider, width: 1.5), // Thicker border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.divider, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
              color: accentColor, width: 2), // Even thicker when focused
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 18), // More padding
        hintStyle: GoogleFonts.nunito(
          fontSize: 16,
          color: AppColors.textSecondary.withOpacity(0.7),
        ),
        // Add subtle shadow for depth
        isDense: false, // Allow for more space
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.divider,
        thickness: 1.5, // Slightly thicker divider
        space: 24, // More spacing around dividers
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: accentColor,
        linearTrackColor: AppColors.divider,
        circularTrackColor: AppColors.divider,
        linearMinHeight: 8.0, // Thicker progress bars like Duolingo
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w600, // Bolder for better readability
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 4, // More elevation
        actionTextColor: accentColor, // Match accent color
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: accentColor,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: GoogleFonts.nunito(
          fontSize: 14, // Larger text for better readability
          fontWeight: FontWeight.w800, // Bolder when selected
        ),
        unselectedLabelStyle: GoogleFonts.nunito(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 12, // More pronounced elevation like Duolingo
        selectedIconTheme: IconThemeData(size: 28), // Larger icons
        unselectedIconTheme: IconThemeData(size: 24),
      ),
      textTheme: GoogleFonts.nunitoTextTheme().copyWith(
        // Updated text styles for better readability
        displayLarge:
            GoogleFonts.nunito(fontWeight: FontWeight.w800, fontSize: 32),
        displayMedium:
            GoogleFonts.nunito(fontWeight: FontWeight.w800, fontSize: 28),
        displaySmall:
            GoogleFonts.nunito(fontWeight: FontWeight.w700, fontSize: 24),
        headlineMedium:
            GoogleFonts.nunito(fontWeight: FontWeight.w700, fontSize: 20),
        titleLarge:
            GoogleFonts.nunito(fontWeight: FontWeight.w700, fontSize: 22),
        titleMedium:
            GoogleFonts.nunito(fontWeight: FontWeight.w700, fontSize: 18),
        bodyLarge:
            GoogleFonts.nunito(fontWeight: FontWeight.w500, fontSize: 16),
        bodyMedium:
            GoogleFonts.nunito(fontWeight: FontWeight.w500, fontSize: 14),
      ),
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
        labelStyle:
            AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
        secondaryLabelStyle: AppTextStyles.bodySmall
            .copyWith(color: accentColor, fontWeight: FontWeight.bold),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: StadiumBorder(side: BorderSide(color: AppColors.divider)),
      ),
    );
  }

  // Dark theme - Now a static method accepting accentColor
  static ThemeData darkTheme(Color accentColor) {
    // Define a brighter secondary text color specifically for dark mode
    final brightSecondaryText = Colors.white.withOpacity(0.85);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: accentColor,
        secondary: accentColor,
        tertiary: AppColors.sakuraPink,
        background: const Color(0xFF121212),
        surface: const Color(0xFF1E1E1E),
        error: AppColors.error.withOpacity(0.9),
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: Colors.white,
        onBackground: Colors.white,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white, // Full white for better visibility
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 22, // Match light theme
          fontWeight: FontWeight.w700,
          color: Colors.white, // Full white
        ),
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF1E1E1E),
        elevation: 2, // More elevation like light theme
        shadowColor: Colors.black.withOpacity(0.3), // Visible shadow
        margin: const EdgeInsets.symmetric(
            vertical: 8, horizontal: 16), // Match light theme
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Match light theme
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.black, // Dark text on bright buttons
          elevation: 2, // Match light theme
          shadowColor: accentColor.withOpacity(0.4),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Match light theme
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: 18, // Match light theme
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
          minimumSize: const Size(88, 48),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accentColor,
          side: BorderSide(
              color: accentColor, width: 2), // Thicker border like light theme
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Match light theme
          ),
          textStyle: GoogleFonts.nunito(
            fontSize: 18, // Match light theme
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
          minimumSize: const Size(88, 48),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentColor,
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w700, // Match light theme
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor:
            const Color(0xFF2A2A2A), // Slightly lighter for better visibility
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16), // Match light theme
          borderSide:
              BorderSide(color: Colors.white.withOpacity(0.2), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide:
              BorderSide(color: Colors.white.withOpacity(0.2), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide:
              BorderSide(color: accentColor, width: 2), // Match light theme
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 18), // Match light theme
        hintStyle: GoogleFonts.nunito(
          fontSize: 16,
          color: Colors.white.withOpacity(0.7), // More visible hint text
        ),
        isDense: false,
      ),
      dividerTheme: DividerThemeData(
        color: Colors.white.withOpacity(0.2), // More visible dividers
        thickness: 1.5, // Match light theme
        space: 24, // Match light theme
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: accentColor,
        linearTrackColor: Colors.white.withOpacity(0.2),
        circularTrackColor: Colors.white.withOpacity(0.2),
        linearMinHeight: 8.0, // Match light theme
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF2A2A2A), // Lighter for better contrast
        contentTextStyle: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w600, // Match light theme
          color: Colors.white, // Full white
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Match light theme
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 4, // Match light theme
        actionTextColor: accentColor,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFF1E1E1E),
        selectedItemColor: accentColor,
        unselectedItemColor:
            Colors.white.withOpacity(0.7), // More visible inactive items
        selectedLabelStyle: GoogleFonts.nunito(
          fontSize: 14, // Match light theme
          fontWeight: FontWeight.w800, // Match light theme
        ),
        unselectedLabelStyle: GoogleFonts.nunito(
          fontSize: 14, // Match light theme
          fontWeight: FontWeight.w600, // Match light theme
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 12, // Match light theme
        selectedIconTheme: IconThemeData(size: 28), // Match light theme
        unselectedIconTheme: IconThemeData(size: 24), // Match light theme
      ),
      textTheme: GoogleFonts.nunitoTextTheme(ThemeData.dark().textTheme)
          .apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          )
          .copyWith(
            // Updated text styles with better visibility
            displayLarge: GoogleFonts.nunito(
                fontWeight: FontWeight.w800, fontSize: 32, color: Colors.white),
            displayMedium: GoogleFonts.nunito(
                fontWeight: FontWeight.w800, fontSize: 28, color: Colors.white),
            displaySmall: GoogleFonts.nunito(
                fontWeight: FontWeight.w700, fontSize: 24, color: Colors.white),
            headlineMedium: GoogleFonts.nunito(
                fontWeight: FontWeight.w700, fontSize: 20, color: Colors.white),
            titleLarge: GoogleFonts.nunito(
                fontWeight: FontWeight.w700, fontSize: 22, color: Colors.white),
            titleMedium: GoogleFonts.nunito(
                fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white),
            bodyLarge: GoogleFonts.nunito(
                fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white),
            bodyMedium: GoogleFonts.nunito(
                fontWeight: FontWeight.w500, fontSize: 14, color: Colors.white),
            bodySmall: GoogleFonts.nunito(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: brightSecondaryText),
            labelLarge: GoogleFonts.nunito(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: brightSecondaryText),
            labelMedium: GoogleFonts.nunito(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: brightSecondaryText),
            labelSmall: GoogleFonts.nunito(
                fontWeight: FontWeight.w500,
                fontSize: 11,
                color: brightSecondaryText),
          ),
      // Include themes from previous version if needed
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
            if (states.contains(MaterialState.selected)) {
              return accentColor.withOpacity(0.3);
            }
            return const Color(0xFF1E1E1E);
          }),
          foregroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
            if (states.contains(MaterialState.selected)) {
              return accentColor;
            }
            return brightSecondaryText; // Use brighter color instead of opacity 0.6
          }),
          side: MaterialStateProperty.all(BorderSide(
              color: Colors.white.withOpacity(0.2))), // Increased opacity
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
        labelStyle: AppTextStyles.bodySmall.copyWith(
          color: brightSecondaryText, // Brighter text
          fontWeight: FontWeight.w500, // Slightly bolder
        ),
        secondaryLabelStyle: AppTextStyles.bodySmall
            .copyWith(color: accentColor, fontWeight: FontWeight.bold),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: StadiumBorder(
            side: BorderSide(
                color: Colors.white.withOpacity(0.2))), // Increased opacity
      ),
    );
  }

  // Character-specific themes
  static ThemeData narutoTheme(Color accentColor) {
    return lightTheme(accentColor).copyWith(
      // Keep light theme but override primary/secondary for Naruto
      colorScheme: lightTheme(accentColor).colorScheme.copyWith(
            primary: AppColors.narutoOrange,
            secondary:
                AppColors.chakraBlue, // Keep blue as secondary for contrast
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
