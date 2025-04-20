import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shinobi_self/features/home/home_screen.dart';
import 'package:shinobi_self/features/onboarding/onboarding_screen.dart';
import 'package:shinobi_self/features/settings/settings_screen.dart';
import 'package:shinobi_self/core/theme/app_theme.dart';
import 'package:shinobi_self/models/user_preferences.dart';
import 'package:shinobi_self/core/navigation/animated_tab_bar.dart';
import 'package:shinobi_self/features/home/home_dashboard.dart';
import 'package:shinobi_self/features/progress/progress_screen.dart';
import 'package:shinobi_self/features/mood/mood_tracker_screen.dart';
import 'package:shinobi_self/features/achievements/achievements_screen.dart';

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
      theme: AppTheme.lightTheme(
          userPrefs.accentColor), // Use light theme definition
      darkTheme: AppTheme.darkTheme(
          userPrefs.accentColor), // Use dark theme definition
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

class MainApp extends ConsumerStatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late TabController _tabController;

  final List<AnimatedTabItem> _tabItems = const [
    AnimatedTabItem(
      icon: Icons.home_rounded,
      label: 'Home',
    ),
    AnimatedTabItem(
      icon: Icons.show_chart_rounded,
      label: 'Progress',
    ),
    AnimatedTabItem(
      icon: Icons.mood_rounded,
      label: 'Mood',
    ),
    AnimatedTabItem(
      icon: Icons.emoji_events_rounded,
      label: 'Achievements',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: _currentIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _tabController.animateTo(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userPrefs = ref.watch(userPrefsProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: userPrefs.themeMode,
      theme: AppTheme.lightTheme(userPrefs.accentColor),
      darkTheme: AppTheme.darkTheme(userPrefs.accentColor),
      home: Scaffold(
        body: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(), // Disable swiping
          children: [
            HomeDashboard(),
            ProgressScreen(),
            MoodTrackerScreen(),
            AchievementsScreen(),
          ],
        ),
        bottomNavigationBar: AnimatedTabBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          items: _tabItems,
          activeColor: userPrefs.accentColor,
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF1E1E1E)
              : Colors.white,
        ),
      ),
    );
  }
}
