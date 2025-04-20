import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shinobi_self/core/theme/app_colors.dart';
import 'package:shinobi_self/core/theme/app_text_styles.dart';
import 'package:shinobi_self/models/user_progress.dart';
import 'package:shinobi_self/models/mission.dart';
import 'package:shinobi_self/models/user_preferences.dart';
import 'package:shinobi_self/models/character_path.dart';
import 'package:shinobi_self/features/home/home_dashboard.dart';
import 'package:intl/intl.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProgress = ref.watch(userProgressProvider);
    final userPrefs = ref.watch(userPrefsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRankCard(context, userProgress, userPrefs.characterPath),
          const SizedBox(height: 24),
          _buildStatsCard(context, ref, userProgress),
          const SizedBox(height: 24),
          _buildHistorySection(context, userProgress),
        ],
      ),
    );
  }

  Widget _buildRankCard(BuildContext context, UserProgress progress,
      CharacterPath? characterPath) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final nextRank = progress.rank.nextRank;
    final nextRankXp = nextRank.requiredXp;
    final currentRankXp = progress.rank.requiredXp;

    // Get character info if available
    final characterInfo =
        characterPath != null ? CharacterInfo.characters[characterPath] : null;

    // Calculate progress percentage towards the next rank
    double progressToNextRank = 0.0;
    if (progress.rank != NinjaRank.hokage) {
      final xpNeededForNextRank = nextRankXp - currentRankXp;
      final xpEarnedInCurrentRank = progress.xp - currentRankXp;
      if (xpNeededForNextRank > 0) {
        // Avoid division by zero
        progressToNextRank =
            (xpEarnedInCurrentRank / xpNeededForNextRank).clamp(0.0, 1.0);
      }
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: progress.rank.color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: characterInfo != null
                      ? ClipOval(
                          child: Image.asset(
                            characterInfo.imagePath,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // Fallback to rank letter if image fails to load
                              return Center(
                                child: Text(
                                  progress.rank.displayName[0],
                                  style: AppTextStyles.heading1.copyWith(
                                    color: progress.rank.color,
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : Center(
                          child: Text(
                            progress.rank.displayName[0],
                            style: AppTextStyles.heading1.copyWith(
                              color: progress.rank.color,
                            ),
                          ),
                        ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Rank',
                        style: isDarkMode
                            ? AppTextStyles.toDarkMode(AppTextStyles.bodySmall)
                            : AppTextStyles.bodySmall,
                      ),
                      Text(
                        progress.rank.displayName,
                        style: AppTextStyles.ninjaRank.copyWith(
                          color: progress.rank.color,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Level ${progress.level}',
                        style: isDarkMode
                            ? AppTextStyles.toDarkMode(AppTextStyles.bodyLarge
                                .copyWith(fontWeight: FontWeight.bold))
                            : AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Total XP',
                      style: isDarkMode
                          ? AppTextStyles.toDarkMode(AppTextStyles.bodySmall)
                          : AppTextStyles.bodySmall,
                    ),
                    Text(
                      '${progress.xp} XP',
                      style: AppTextStyles.xpCounter.copyWith(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (progress.rank != NinjaRank.hokage) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress to ${nextRank.displayName}',
                        style: isDarkMode
                            ? AppTextStyles.toDarkMode(AppTextStyles.bodyMedium)
                            : AppTextStyles.bodyMedium,
                      ),
                      Text(
                        '${progress.xp} / ${nextRankXp} XP',
                        style: isDarkMode
                            ? AppTextStyles.toDarkMode(AppTextStyles.bodySmall)
                            : AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progressToNextRank,
                    backgroundColor:
                        isDarkMode ? Colors.grey[800] : AppColors.divider,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(progress.rank.color),
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Need ${nextRankXp - progress.xp} more XP to reach ${nextRank.displayName}',
                    style: isDarkMode
                        ? AppTextStyles.toDarkMode(AppTextStyles.bodySmall)
                        : AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ] else ...[
              Text(
                'Congratulations! You\'ve reached the highest rank of Hokage!',
                style: isDarkMode
                    ? AppTextStyles.toDarkMode(
                        AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.hokageColor,
                        fontWeight: FontWeight.bold,
                      ))
                    : AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.hokageColor,
                        fontWeight: FontWeight.bold,
                      ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(
      BuildContext context, WidgetRef ref, UserProgress progress) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final totalDailyMissions = ref.watch(dailyMissionsProvider).maybeWhen(
          data: (missions) => missions.length,
          orElse: () => 0, // Default to 0 if loading or error
        );

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Stats',
              style: isDarkMode
                  ? AppTextStyles.toDarkMode(AppTextStyles.heading3)
                  : AppTextStyles.heading3,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  context: context,
                  icon: Icons.local_fire_department,
                  color: AppColors.narutoOrange,
                  label: 'Current Streak',
                  value: '${progress.streak} days',
                ),
                _buildStatItem(
                  context: context,
                  icon: Icons.check_circle,
                  color: AppColors.success,
                  label: 'Missions Today',
                  value: '${progress.completedMissions}/${totalDailyMissions}',
                ),
                _buildStatItem(
                  context: context,
                  icon: Icons.history,
                  color: AppColors.chakraBlue,
                  label: 'Total Missions',
                  value: '${progress.totalMissionsCompleted}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String label,
    required String value,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 32,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: isDarkMode
              ? AppTextStyles.toDarkMode(
                  AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold))
              : AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: isDarkMode
              ? AppTextStyles.toDarkMode(AppTextStyles.bodySmall)
              : AppTextStyles.bodySmall,
        ),
      ],
    );
  }

  Widget _buildHistorySection(BuildContext context, UserProgress progress) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // In a real app, this would be loaded from a database
    final historyItems = [
      {
        'date': DateTime.now().subtract(const Duration(days: 0)),
        'event': 'Completed mission: Journal a proud moment',
        'xp': 40,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 0)),
        'event': 'Completed mission: Smile in the mirror',
        'xp': 30,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'event': 'Completed mission: Text a friend to check in',
        'xp': 40,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'event': 'Reached Chunin rank',
        'xp': 0,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 2)),
        'event': 'Completed mission: Avoid phone for 1 hour',
        'xp': 60,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: isDarkMode
              ? AppTextStyles.toDarkMode(AppTextStyles.heading2)
              : AppTextStyles.heading2,
        ),
        const SizedBox(height: 16),
        ...historyItems
            .map((item) => _buildHistoryItem(
                  context,
                  date: item['date'] as DateTime,
                  event: item['event'] as String,
                  xp: item['xp'] as int,
                ))
            .toList(),
      ],
    );
  }

  Widget _buildHistoryItem(
    BuildContext context, {
    required DateTime date,
    required String event,
    required int xp,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final dateFormat = DateFormat('MMM d');
    final formattedDate = dateFormat.format(date);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDarkMode ? Colors.white24 : AppColors.divider,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppColors.chakraBlue.withOpacity(0.3)
                  : AppColors.chakraBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                formattedDate,
                style: isDarkMode
                    ? AppTextStyles.toDarkMode(AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ))
                    : AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              event,
              style: isDarkMode
                  ? AppTextStyles.toDarkMode(AppTextStyles.bodyMedium)
                  : AppTextStyles.bodyMedium,
            ),
          ),
          if (xp > 0)
            Text(
              '+$xp XP',
              style: AppTextStyles.xpCounter,
            ),
        ],
      ),
    );
  }
}
