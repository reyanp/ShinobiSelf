import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shinobi_self/core/theme/app_colors.dart';
import 'package:shinobi_self/core/theme/app_text_styles.dart';
import 'package:shinobi_self/models/achievement.dart';
import 'package:shinobi_self/models/user_progress.dart';

// Provider for achievements data
final achievementsProvider = StateNotifierProvider<AchievementsNotifier, List<Achievement>>((ref) {
  final userProgress = ref.watch(userProgressProvider);
  return AchievementsNotifier(userProgress);
});

class AchievementsNotifier extends StateNotifier<List<Achievement>> {
  final UserProgress userProgress;

  AchievementsNotifier(this.userProgress) : super(_initialAchievements) {
    _updateAchievementsStatus();
  }

  void _updateAchievementsStatus() {
    state = state.map((achievement) {
      bool isUnlocked = false;
      // Add achievement unlocking logic based on userProgress
      switch (achievement.id) {
        case 'genin_rank':
          isUnlocked = userProgress.rank.index >= NinjaRank.genin.index;
          break;
        case 'chunin_rank':
          isUnlocked = userProgress.rank.index >= NinjaRank.chunin.index;
          break;
        case 'first_mission':
          isUnlocked = userProgress.totalMissionsCompleted >= 1;
          break;
        case 'ten_missions':
           isUnlocked = userProgress.totalMissionsCompleted >= 10;
           break;
        case 'three_day_streak':
          isUnlocked = userProgress.streak >= 3;
          break;
        // Add more achievement checks here
      }
      return achievement.copyWith(isUnlocked: isUnlocked);
    }).toList();
  }

  // Example method to potentially force-update if needed elsewhere
  void checkAchievements() {
     _updateAchievementsStatus();
  }

  static final List<Achievement> _initialAchievements = [
    Achievement(
      id: 'genin_rank',
      title: 'Welcome, Genin!',
      description: 'Begin your journey as a Shinobi.',
      reward: 'Unlock Character Customization',
      icon: Icons.star_border,
    ),
    Achievement(
      id: 'chunin_rank',
      title: 'Chunin Promotion',
      description: 'Prove your skills and reach Chunin rank.',
      reward: 'New Mission Types',
      icon: Icons.military_tech,
    ),
    Achievement(
      id: 'jounin_rank',
      title: 'Elite Jounin',
      description: 'Become a high-ranking Jounin.',
      reward: 'Exclusive Jounin Jacket Skin',
      icon: Icons.shield,
    ),
    Achievement(
      id: 'hokage_rank',
      title: "The Hokage's Will",
      description: 'Achieve the highest rank: Hokage!',
      reward: 'Legendary Hokage Cloak',
      icon: Icons.local_fire_department,
      isHidden: true, // Example of a hidden achievement until unlocked
    ),
    Achievement(
      id: 'first_mission',
      title: 'First Step',
      description: 'Complete your first mission.',
      reward: '+50 Bonus XP',
      icon: Icons.directions_run,
    ),
     Achievement(
      id: 'ten_missions',
      title: 'Mission Specialist',
      description: 'Complete 10 missions.',
      reward: 'Mission Master Badge',
      icon: Icons.assignment_turned_in,
    ),
    Achievement(
      id: 'three_day_streak',
      title: 'Consistency is Key',
      description: 'Maintain a 3-day mission streak.',
      reward: '+100 Bonus XP',
      icon: Icons.calendar_today,
    ),
    Achievement(
      id: 'mood_master',
      title: 'Mood Tracker',
      description: 'Log your mood for 7 consecutive days.',
      reward: 'Zen Garden Theme',
      icon: Icons.sentiment_satisfied_alt,
       isHidden: true,
    ),
  ];
}


class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievements = ref.watch(achievementsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
        automaticallyImplyLeading: false, // Remove back button if it's a main tab
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          final achievement = achievements[index];
          // Only show hidden achievements if they are unlocked
          if (achievement.isHidden && !achievement.isUnlocked) {
            return _buildLockedAchievementCard(achievement);
          } else {
            return _buildAchievementCard(achievement);
          }
        },
      ),
    );
  }

  Widget _buildAchievementCard(Achievement achievement) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: achievement.isUnlocked ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: achievement.isUnlocked ? AppColors.hokageColor : AppColors.divider,
          width: achievement.isUnlocked ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              achievement.icon,
              size: 40,
              color: achievement.isUnlocked ? AppColors.chakraBlue : AppColors.textSecondary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    achievement.title,
                    style: AppTextStyles.heading3.copyWith(
                      color: achievement.isUnlocked ? AppColors.textPrimary : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    achievement.description,
                    style: AppTextStyles.bodyMedium.copyWith(
                       color: achievement.isUnlocked ? AppColors.textPrimary : AppColors.textSecondary,
                    ),
                  ),
                   const SizedBox(height: 8),
                   if (achievement.isUnlocked)
                    Text(
                      'Reward: ${achievement.reward}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
            if (achievement.isUnlocked)
              const Icon(Icons.check_circle, color: AppColors.success, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildLockedAchievementCard(Achievement achievement) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 1,
      color: AppColors.silverGray.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
         side: const BorderSide(color: AppColors.divider),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              Icons.question_mark_rounded,
              size: 40,
              color: AppColors.textSecondary,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hidden Achievement',
                    style: AppTextStyles.heading3,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Keep playing to unlock!',
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 