import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shinobi_self/features/home/home_screen.dart';
import 'package:shinobi_self/features/onboarding/onboarding_screen.dart';
import 'package:shinobi_self/features/settings/settings_screen.dart';
import 'package:shinobi_self/core/theme/app_theme.dart';
import 'package:shinobi_self/models/user_preferences.dart';

void main() {
  // Ensure widgets are initialized for shared_preferences
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: ShinobiSelfApp()));
}

class ShinobiSelfApp extends ConsumerWidget {
  const ShinobiSelfApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch user preferences for theme changes
    final userPrefs = ref.watch(userPrefsProvider);
    
    // --- Simplified Theme Logic ---
    // ThemeData is now determined ONLY by userPrefs.themeMode and userPrefs.accentColor
    // The MaterialApp handles switching between lightTheme and darkTheme based on themeMode.

    return MaterialApp(
      title: 'Shinobi Self',
      themeMode: userPrefs.themeMode, // Use theme mode directly from prefs
      theme: AppTheme.lightTheme(userPrefs.accentColor), // Use light theme definition
      darkTheme: AppTheme.darkTheme(userPrefs.accentColor), // Use dark theme definition
      debugShowCheckedModeBanner: false,
      // Use initialRoute for clarity
      initialRoute: userPrefs.hasCompletedOnboarding ? '/home' : '/onboarding',
      routes: {
        // Keep named routes for navigation
        '/onboarding': (context) => const OnboardingScreen(),
        '/home': (context) => const HomeScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
