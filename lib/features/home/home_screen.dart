import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shinobi_self/core/theme/app_colors.dart';
import 'package:shinobi_self/core/theme/app_text_styles.dart';
import 'package:shinobi_self/models/character_path.dart';
import 'package:shinobi_self/models/user_preferences.dart';
import 'package:shinobi_self/utils/character_evolution_helper.dart';
import 'package:shinobi_self/features/home/home_dashboard.dart';
import 'package:shinobi_self/features/profile/profile_screen.dart';
import 'package:shinobi_self/features/progress/progress_screen.dart';
import 'package:shinobi_self/features/mood/mood_tracker_screen.dart';
import 'package:shinobi_self/features/achievements/achievements_screen.dart';
import 'package:shinobi_self/features/settings/settings_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shinobi Self'),
        leading: _buildProfileButton(),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
            },
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_emotions),
            label: 'Mood',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Achievements',
          ),
        ],
      ),
    );
  }
  
  Widget _buildProfileButton() {
    final userPrefs = ref.watch(userPrefsProvider);
    final characterPath = userPrefs.characterPath;
    final selectedProfileImage = userPrefs.selectedProfileImage;
    
    if (characterPath == null) {
      return const Icon(Icons.person);
    }
    
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/profile');
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Hero(
          tag: 'profile_avatar',
          child: CircleAvatar(
            radius: 18,
            backgroundImage: AssetImage(
              CharacterEvolutionHelper.getCharacterImagePath(characterPath, selectedProfileImage),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return const HomeDashboard();
      case 1:
        return const ProgressScreen();
      case 2:
        return const MoodTrackerScreen();
      case 3:
        return const AchievementsScreen();
      default:
        return const HomeDashboard();
    }
  }
}
