import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shinobi_self/core/theme/app_colors.dart';
import 'package:shinobi_self/core/theme/app_text_styles.dart';
import 'package:shinobi_self/models/user_progress.dart';
import 'package:shinobi_self/models/mission.dart';
import 'package:shinobi_self/models/user_preferences.dart';
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
          _buildRankCard(context, userProgress),
          const SizedBox(height: 24),
          _buildStatsCard(context, userProgress),
          const SizedBox(height: 24),
          _buildHistorySection(context, userProgress),
        ],
      ),
    );
  }
  
  Widget _buildRankCard(BuildContext context, UserProgress progress) {
    final nextRank = progress.rank.nextRank;
    final nextRankXp = nextRank.requiredXp;
    final currentRankXp = progress.rank.requiredXp;
    
    // Calculate progress percentage towards the next rank
    double progressToNextRank = 0.0;
    if (progress.rank != NinjaRank.hokage) {
       final xpNeededForNextRank = nextRankXp - currentRankXp;
       final xpEarnedInCurrentRank = progress.xp - currentRankXp;
       if (xpNeededForNextRank > 0) { // Avoid division by zero
           progressToNextRank = (xpEarnedInCurrentRank / xpNeededForNextRank).clamp(0.0, 1.0);
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
                  child: Center(
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
                        style: AppTextStyles.bodySmall,
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
                        style: AppTextStyles.bodyLarge.copyWith(
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
                      style: AppTextStyles.bodySmall,
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
                        style: AppTextStyles.bodyMedium,
                      ),
                      Text(
                        '${progress.xp} / ${nextRankXp} XP',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progressToNextRank,
                    backgroundColor: AppColors.divider,
                    valueColor: AlwaysStoppedAnimation<Color>(progress.rank.color),
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Need ${nextRankXp - progress.xp} more XP to reach ${nextRank.displayName}',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ] else ...[
              Text(
                'Congratulations! You\'ve reached the highest rank of Hokage!',
                style: AppTextStyles.bodyMedium.copyWith(
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
  
  Widget _buildStatsCard(BuildContext context, UserProgress progress) {
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
              style: AppTextStyles.heading3,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  icon: Icons.local_fire_department,
                  color: AppColors.narutoOrange,
                  label: 'Current Streak',
                  value: '${progress.streak} days',
                ),
                _buildStatItem(
                  icon: Icons.check_circle,
                  color: AppColors.success,
                  label: 'Missions Today',
                  value: '${progress.completedMissions}/3',
                ),
                _buildStatItem(
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
    required IconData icon,
    required Color color,
    required String label,
    required String value,
  }) {
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
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.bodySmall,
        ),
      ],
    );
  }
  
  Widget _buildHistorySection(BuildContext context, UserProgress progress) {
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
          style: AppTextStyles.heading2,
        ),
        const SizedBox(height: 16),
        ...historyItems.map((item) => _buildHistoryItem(
          context,
          date: item['date'] as DateTime,
          event: item['event'] as String,
          xp: item['xp'] as int,
        )).toList(),
      ],
    );
  }
  
  Widget _buildHistoryItem(
    BuildContext context, {
    required DateTime date,
    required String event,
    required int xp,
  }) {
    final dateFormat = DateFormat('MMM d');
    final formattedDate = dateFormat.format(date);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.divider,
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
              color: AppColors.chakraBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                formattedDate,
                style: AppTextStyles.bodySmall.copyWith(
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
              style: AppTextStyles.bodyMedium,
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
