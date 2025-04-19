import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shinobi_self/features/home/home_screen.dart';
import 'package:shinobi_self/features/onboarding/onboarding_screen.dart';
import 'package:shinobi_self/features/progress/progress_screen.dart';
import 'package:shinobi_self/features/mood/mood_tracker_screen.dart';
import 'package:shinobi_self/features/rewards/rewards_screen.dart';
import 'package:shinobi_self/features/settings/settings_screen.dart';
import 'package:shinobi_self/core/theme/app_theme.dart';
import 'package:shinobi_self/models/user_preferences.dart';
import 'package:shinobi_self/models/character_path.dart';

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
    final selectedCharacter = ref.watch(selectedCharacterProvider);
    
    // Determine which theme to use based on character selection
    ThemeData appTheme = AppTheme.lightTheme(userPrefs.accentColor);
    if (userPrefs.characterPath != null) {
      switch (userPrefs.characterPath!) {
        case CharacterPath.naruto:
          appTheme = AppTheme.narutoTheme(userPrefs.accentColor);
          break;
        case CharacterPath.sasuke:
          appTheme = AppTheme.sasukeTheme(userPrefs.accentColor);
          break;
        case CharacterPath.sakura:
          appTheme = AppTheme.sakuraTheme(userPrefs.accentColor);
          break;
      }
    } else if (selectedCharacter != null) {
      // During onboarding, preview the theme based on selection
      switch (selectedCharacter) {
        case CharacterPath.naruto:
          appTheme = AppTheme.narutoTheme(userPrefs.accentColor);
          break;
        case CharacterPath.sasuke:
          appTheme = AppTheme.sasukeTheme(userPrefs.accentColor);
          break;
        case CharacterPath.sakura:
          appTheme = AppTheme.sakuraTheme(userPrefs.accentColor);
          break;
      }
    }

    return MaterialApp(
      title: 'Shinobi Self',
      themeMode: userPrefs.themeMode,
      theme: appTheme,
      darkTheme: AppTheme.darkTheme(userPrefs.accentColor),
      debugShowCheckedModeBanner: false,
      initialRoute: userPrefs.hasCompletedOnboarding ? '/home' : '/onboarding',
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/home': (context) => const HomeScreen(),
        '/progress': (context) => const ProgressScreen(),
        '/mood': (context) => const MoodTrackerScreen(),
        '/rewards': (context) => const RewardsScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
