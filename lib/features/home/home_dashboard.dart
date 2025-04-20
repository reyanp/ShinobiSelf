import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shinobi_self/core/theme/app_colors.dart';
import 'package:shinobi_self/core/theme/app_text_styles.dart';
import 'package:shinobi_self/models/character_path.dart';
import 'package:shinobi_self/models/mission.dart';
import 'package:shinobi_self/models/user_preferences.dart';
import 'package:shinobi_self/models/mood_entry.dart';
import 'package:shinobi_self/models/user_progress.dart';
import 'package:shinobi_self/features/achievements/achievements_screen.dart';
import 'package:shinobi_self/core/animations/animation_helpers.dart';
import 'package:shinobi_self/features/home/components/mission_card.dart';
import 'package:shinobi_self/features/home/components/animated_user_header.dart';

// Provider for daily missions
final dailyMissionsProvider = StateProvider<List<Mission>>((ref) {
  final userPrefs =
      ref.watch(userPrefsProvider.select((prefs) => prefs.characterPath));
  if (userPrefs != null) {
    return MissionData.getDailyMissions(userPrefs);
  }
  return [];
});

// Provider for weekly missions
final weeklyMissionsProvider = StateProvider<List<Mission>>((ref) {
  final userPrefs =
      ref.watch(userPrefsProvider.select((prefs) => prefs.characterPath));
  if (userPrefs != null) {
    return MissionData.getWeeklyMissions(userPrefs);
  }
  return [];
});

// Timer provider to check for mission resets
final missionTimerProvider = StreamProvider<void>((ref) {
  return Stream.periodic(const Duration(minutes: 1), (count) {
    final dailyMissions = ref.read(dailyMissionsProvider);
    final weeklyMissions = ref.read(weeklyMissionsProvider);

    // Check if any missions need to be reset
    bool needsDailyReset = dailyMissions.any((m) => m.shouldReset);
    bool needsWeeklyReset = weeklyMissions.any((m) => m.shouldReset);

    if (needsDailyReset) {
      final characterPath =
          ref.read(userPrefsProvider.select((prefs) => prefs.characterPath));
      if (characterPath != null) {
        ref.read(dailyMissionsProvider.notifier).state =
            MissionData.getDailyMissions(characterPath);
      }
    }

    if (needsWeeklyReset) {
      final characterPath =
          ref.read(userPrefsProvider.select((prefs) => prefs.characterPath));
      if (characterPath != null) {
        ref.read(weeklyMissionsProvider.notifier).state =
            MissionData.getWeeklyMissions(characterPath);
      }
    }
  });
});

// Provider for user XP
final userXpProvider = StateProvider<int>((ref) => 0);

// Provider for user streak
final userStreakProvider = StateProvider<int>((ref) => 0);

// Provider for selected mood
final selectedMoodProvider = StateProvider<String?>((ref) => null);

// Provider for daily mood submission status
final hasMoodSubmittedTodayProvider = StateProvider<bool>((ref) => false);

class HomeDashboard extends ConsumerWidget {
  const HomeDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the timer to trigger mission resets
    ref.watch(missionTimerProvider);

    final userPrefs = ref.watch(userPrefsProvider);
    final dailyMissions = ref.watch(dailyMissionsProvider);
    final weeklyMissions = ref.watch(weeklyMissionsProvider);
    final userXp = ref.watch(userXpProvider);
    final userProgress = ref.watch(userProgressProvider);

    // Sync userStreakProvider with userProgress.streak
    final userStreak = userProgress.streak;
    // Update the userStreakProvider to match the userProgressProvider streak value
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userStreakProvider.notifier).state = userStreak;
    });

    // For demo purposes, set a default character path if none is selected
    if (userPrefs.characterPath == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(userPrefsProvider.notifier).state = userPrefs.copyWith(
          characterPath: CharacterPath.naruto,
          hasCompletedOnboarding: true,
        );
      });
      return const Center(child: CircularProgressIndicator());
    }

    final characterInfo = CharacterInfo.characters[userPrefs.characterPath]!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedUserHeader(
            characterInfo: characterInfo,
            userXp: userXp,
            userStreak: userStreak,
            userAccentColor: userPrefs.accentColor,
          ),
          const SizedBox(height: 24),
          _buildDailyMissions(context, ref, dailyMissions),
          const SizedBox(height: 24),
          _buildWeeklyMissions(context, ref, weeklyMissions),
          const SizedBox(height: 24),
          _buildMoodTracker(context),
        ],
      ),
    );
  }

  Widget _buildDailyMissions(
      BuildContext context, WidgetRef ref, List<Mission> missions) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.task_alt,
              color: AppColors.narutoOrange,
              size: 28,
            ),
            const SizedBox(width: 8),
            Text(
              'Daily Missions',
              style: isDarkMode
                  ? AppTextStyles.toDarkMode(AppTextStyles.heading2)
                  : AppTextStyles.heading2,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Complete these missions to earn XP and level up',
          style: isDarkMode
              ? AppTextStyles.toDarkMode(AppTextStyles.bodySmall)
              : AppTextStyles.bodySmall,
        ),
        const SizedBox(height: 16),
        if (missions.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Text(
                'No missions available at the moment',
                style: isDarkMode
                    ? AppTextStyles.toDarkMode(AppTextStyles.bodyMedium)
                    : AppTextStyles.bodyMedium,
              ),
            ),
          )
        else
          ...missions.asMap().entries.map((entry) {
            // Add staggered animation delay based on index
            final index = entry.key;
            final mission = entry.value;
            return AnimatedMissionCard(
              mission: mission,
              onComplete: (mission) => _completeMission(ref, mission),
            );
          }).toList(),
      ],
    );
  }

  Widget _buildWeeklyMissions(
      BuildContext context, WidgetRef ref, List<Mission> missions) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.extension,
              color: AppColors.chakraBlue,
              size: 28,
            ),
            const SizedBox(width: 8),
            Text(
              'Weekly Challenges',
              style: isDarkMode
                  ? AppTextStyles.toDarkMode(AppTextStyles.heading2)
                  : AppTextStyles.heading2,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'More rewarding missions that reset weekly',
          style: isDarkMode
              ? AppTextStyles.toDarkMode(AppTextStyles.bodySmall)
              : AppTextStyles.bodySmall,
        ),
        const SizedBox(height: 16),
        if (missions.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Text(
                'No weekly challenges available at the moment',
                style: isDarkMode
                    ? AppTextStyles.toDarkMode(AppTextStyles.bodyMedium)
                    : AppTextStyles.bodyMedium,
              ),
            ),
          )
        else
          ...missions.asMap().entries.map((entry) {
            // Add staggered animation delay based on index
            final index = entry.key;
            final mission = entry.value;
            return AnimatedMissionCard(
              mission: mission,
              onComplete: (mission) => _completeMission(ref, mission),
            );
          }).toList(),
      ],
    );
  }

  Widget _buildTimeUntilReset(DateTime? resetTime) {
    if (resetTime == null) return const SizedBox.shrink();

    final now = DateTime.now();
    final difference = resetTime.difference(now);

    String timeText;
    if (difference.inDays > 0) {
      timeText = '${difference.inDays}d ${difference.inHours % 24}h';
    } else if (difference.inHours > 0) {
      timeText = '${difference.inHours}h ${difference.inMinutes % 60}m';
    } else {
      timeText = '${difference.inMinutes % 60}m';
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.timer_outlined, size: 16),
        const SizedBox(width: 4),
        Text(
          'Resets in $timeText',
          style: AppTextStyles.toDarkMode(AppTextStyles.bodySmall),
        ),
      ],
    );
  }

  Widget _buildMoodTracker(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final selectedMood = ref.watch(selectedMoodProvider);
        final hasMoodSubmittedToday = ref.watch(hasMoodSubmittedTodayProvider);
        final userAccentColor = ref.watch(userPrefsProvider).accentColor;
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Mood Check-in',
              style: isDarkMode
                  ? AppTextStyles.toDarkMode(AppTextStyles.heading2)
                  : AppTextStyles.heading2,
            ),
            const SizedBox(height: 8),
            Text(
              hasMoodSubmittedToday
                  ? 'Thanks for checking in today!'
                  : 'How are you feeling today?',
              style: isDarkMode
                  ? AppTextStyles.toDarkMode(AppTextStyles.bodyMedium)
                  : AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMoodOption('😢', 'Sad', selectedMood, ref,
                            userAccentColor, isDarkMode),
                        _buildMoodOption('😐', 'Okay', selectedMood, ref,
                            userAccentColor, isDarkMode),
                        _buildMoodOption('🙂', 'Good', selectedMood, ref,
                            userAccentColor, isDarkMode),
                        _buildMoodOption('😄', 'Great', selectedMood, ref,
                            userAccentColor, isDarkMode),
                        _buildMoodOption('🤩', 'Amazing', selectedMood, ref,
                            userAccentColor, isDarkMode),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: hasMoodSubmittedToday
                            ? null
                            : () => _submitMood(context, ref, selectedMood),
                        child: Text(
                          hasMoodSubmittedToday ? 'Submitted' : 'Submit Mood',
                          style: AppTextStyles.buttonMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMoodOption(String emoji, String label, String? selectedMood,
      WidgetRef ref, Color accentColor, bool isDarkMode) {
    final isSelected = selectedMood == emoji;

    return GestureDetector(
      onTap: () {
        ref.read(selectedMoodProvider.notifier).state = emoji;
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected
                  ? accentColor.withOpacity(0.2) // Use user accent color
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 32),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: isDarkMode
                ? AppTextStyles.toDarkMode(AppTextStyles.bodySmall).copyWith(
                    color: isSelected ? accentColor : null,
                    fontWeight: isSelected ? FontWeight.bold : null,
                  )
                : AppTextStyles.bodySmall.copyWith(
                    color: isSelected ? accentColor : null,
                    fontWeight: isSelected ? FontWeight.bold : null,
                  ),
          ),
        ],
      ),
    );
  }

  void _submitMood(BuildContext context, WidgetRef ref, String? selectedMood) {
    if (selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a mood first'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Create new mood entry
    final moodType = MoodType.values.firstWhere(
      (type) => type.emoji == selectedMood,
      orElse: () => MoodType.okay,
    );

    final newEntry = MoodEntry(
      date: DateTime.now(),
      mood: moodType,
    );

    // Add to mood entries
    final currentEntries = ref.read(moodEntriesProvider);
    ref.read(moodEntriesProvider.notifier).state = [
      newEntry,
      ...currentEntries
    ];

    // Update submission status
    ref.read(hasMoodSubmittedTodayProvider.notifier).state = true;

    // Update XP and progress
    final currentXp = ref.read(userXpProvider);
    final moodXpReward = 20; // XP reward for tracking mood
    final newXp = currentXp + moodXpReward;
    ref.read(userXpProvider.notifier).state = newXp;

    // Update user progress
    final currentProgress = ref.read(userProgressProvider);
    ref.read(userProgressProvider.notifier).state = currentProgress.copyWith(
      xp: newXp,
      level: _calculateLevel(newXp),
      rank: _calculateRank(newXp),
    );

    // Check achievements after updating progress
    ref.read(achievementsProvider.notifier).checkAchievements();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mood submitted: ${moodType.label}'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _completeMission(WidgetRef ref, Mission mission) {
    // Update the mission to completed
    if (mission.frequency == MissionFrequency.daily) {
      final missions = ref.read(dailyMissionsProvider);
      final updatedMissions = missions.map((m) {
        if (m.id == mission.id) {
          return m.copyWith(
            isCompleted: true,
            completedAt: DateTime.now(),
          );
        }
        return m;
      }).toList();

      // Update missions list
      ref.read(dailyMissionsProvider.notifier).state = updatedMissions;

      // Check if all missions are completed to update streak
      final allCompleted = updatedMissions.every((m) => m.isCompleted);
      if (allCompleted) {
        // Update streak in both providers
        final currentStreak = ref.read(userStreakProvider);
        ref.read(userStreakProvider.notifier).state = currentStreak + 1;

        // Update streak in userProgressProvider
        final currentProgress = ref.read(userProgressProvider);
        ref.read(userProgressProvider.notifier).state =
            currentProgress.copyWith(
          streak: currentProgress.streak + 1,
        );
      }
    } else {
      // Handle weekly missions
      final missions = ref.read(weeklyMissionsProvider);
      final updatedMissions = missions.map((m) {
        if (m.id == mission.id) {
          return m.copyWith(
            isCompleted: true,
            completedAt: DateTime.now(),
          );
        }
        return m;
      }).toList();

      // Update weekly missions list
      ref.read(weeklyMissionsProvider.notifier).state = updatedMissions;
    }

    // Update XP and progress
    final currentXp = ref.read(userXpProvider);
    final newXp = currentXp + mission.xpReward;
    ref.read(userXpProvider.notifier).state = newXp;

    // Update user progress
    final currentProgress = ref.read(userProgressProvider);
    ref.read(userProgressProvider.notifier).state = currentProgress.copyWith(
      xp: newXp,
      level: _calculateLevel(newXp),
      rank: _calculateRank(newXp),
      completedMissions: currentProgress.completedMissions + 1,
      totalMissionsCompleted: currentProgress.totalMissionsCompleted + 1,
    );

    // Check achievements after updating progress
    ref.read(achievementsProvider.notifier).checkAchievements();
  }

  int _calculateLevel(int xp) {
    // Every 100 XP is a new level
    return (xp / 100).floor() + 1;
  }

  NinjaRank _calculateRank(int xp) {
    if (xp >= 2000) return NinjaRank.hokage;
    if (xp >= 1000) return NinjaRank.jounin;
    if (xp >= 500) return NinjaRank.chunin;
    return NinjaRank.genin;
  }

  String _getNinjaRank(int xp) {
    if (xp >= 2000) return 'Hokage';
    if (xp >= 1000) return 'Jounin';
    if (xp >= 500) return 'Chunin';
    return 'Genin';
  }

  String _getNextRank(String currentRank) {
    switch (currentRank) {
      case 'Genin':
        return 'Chunin';
      case 'Chunin':
        return 'Jounin';
      case 'Jounin':
        return 'Hokage';
      default:
        return 'Hokage';
    }
  }

  int _getNextRankXp(int currentXp) {
    if (currentXp < 500) return 500;
    if (currentXp < 1000) return 1000;
    if (currentXp < 2000) return 2000;
    return 3000; // Beyond Hokage
  }

  Color _getPathColor(CharacterPath path) {
    switch (path) {
      case CharacterPath.naruto:
        return AppColors.narutoPathColor;
      case CharacterPath.sasuke:
        return AppColors.sasukePathColor;
      case CharacterPath.sakura:
        return AppColors.sakuraPathColor;
    }
  }

  Color _getRankColor(String rank) {
    switch (rank) {
      case 'Genin':
        return AppColors.geninColor;
      case 'Chunin':
        return AppColors.chuninColor;
      case 'Jounin':
        return AppColors.jouninColor;
      case 'Hokage':
        return AppColors.hokageColor;
      default:
        return AppColors.chakraBlue;
    }
  }
}
