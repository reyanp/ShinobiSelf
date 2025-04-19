import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shinobi_self/core/theme/app_colors.dart';
import 'package:shinobi_self/core/theme/app_text_styles.dart';
import 'package:shinobi_self/models/reward.dart';
import 'package:shinobi_self/models/user_progress.dart';

class RewardsScreen extends ConsumerWidget {
  const RewardsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rewards = ref.watch(rewardsProvider);
    final userProgress = ref.watch(userProgressProvider);
    
    // Update rewards based on user progress
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final oldRewards = rewards;
      final updatedRewards = RewardsService.updateRewards(rewards, userProgress);
      
      if (updatedRewards != oldRewards) {
        ref.read(rewardsProvider.notifier).state = updatedRewards;
        
        // Check for newly unlocked rewards
        final newlyUnlocked = RewardsService.getNewlyUnlockedRewards(oldRewards, updatedRewards);
        if (newlyUnlocked.isNotEmpty) {
          _showRewardUnlockedDialog(context, newlyUnlocked.first);
        }
      }
    });
    
    final unlockedRewards = RewardsService.getUnlockedRewards(rewards);
    final lockedRewards = RewardsService.getLockedRewards(rewards);
    final nextRewards = RewardsService.getNextRewardsToUnlock(rewards, userProgress.xp);
    
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Rewards'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Quotes'),
              Tab(text: 'Badges'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildRewardsTab(context, unlockedRewards, lockedRewards, nextRewards, userProgress),
            _buildRewardsTypeTab(context, rewards, RewardType.quote, userProgress),
            _buildRewardsTypeTab(context, rewards, RewardType.badge, userProgress),
          ],
        ),
      ),
    );
  }
  
  Widget _buildRewardsTab(
    BuildContext context,
    List<Reward> unlockedRewards,
    List<Reward> lockedRewards,
    List<Reward> nextRewards,
    UserProgress userProgress,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProgressSection(context, userProgress, nextRewards),
          const SizedBox(height: 24),
          Text(
            'Unlocked Rewards (${unlockedRewards.length})',
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: 16),
          if (unlockedRewards.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Complete missions to unlock rewards!',
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: unlockedRewards.length,
              itemBuilder: (context, index) {
                return _buildRewardCard(context, unlockedRewards[index], true);
              },
            ),
          const SizedBox(height: 24),
          Text(
            'Locked Rewards (${lockedRewards.length})',
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: lockedRewards.length,
            itemBuilder: (context, index) {
              return _buildRewardCard(context, lockedRewards[index], false);
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildRewardsTypeTab(
    BuildContext context,
    List<Reward> allRewards,
    RewardType type,
    UserProgress userProgress,
  ) {
    final typeRewards = RewardsService.getRewardsByType(allRewards, type);
    final unlockedRewards = RewardsService.getUnlockedRewards(typeRewards);
    final lockedRewards = RewardsService.getLockedRewards(typeRewards);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Unlocked ${type.displayName}s (${unlockedRewards.length})',
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: 16),
          if (unlockedRewards.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Complete missions to unlock ${type.displayName.toLowerCase()}s!',
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: unlockedRewards.length,
              itemBuilder: (context, index) {
                return _buildRewardCard(context, unlockedRewards[index], true);
              },
            ),
          const SizedBox(height: 24),
          Text(
            'Locked ${type.displayName}s (${lockedRewards.length})',
            style: AppTextStyles.heading2,
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: lockedRewards.length,
            itemBuilder: (context, index) {
              return _buildRewardCard(context, lockedRewards[index], false);
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildProgressSection(
    BuildContext context,
    UserProgress userProgress,
    List<Reward> nextRewards,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.emoji_events,
                  color: AppColors.hokageColor,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Progress',
                        style: AppTextStyles.heading3,
                      ),
                      Text(
                        'Current XP: ${userProgress.xp}',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (nextRewards.isNotEmpty) ...[
              Text(
                'Next Reward${nextRewards.length > 1 ? "s" : ""} to Unlock:',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...nextRewards.map((reward) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Icon(
                        reward.type.icon,
                        color: reward.type.color,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          reward.title,
                          style: AppTextStyles.bodyMedium,
                        ),
                      ),
                      Text(
                        '${reward.requiredXp} XP',
                        style: AppTextStyles.xpCounter,
                      ),
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: nextRewards.isEmpty ? 1.0 : userProgress.xp / nextRewards.first.requiredXp,
                backgroundColor: AppColors.divider,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.chakraBlue),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 8),
              Text(
                nextRewards.isEmpty
                    ? 'All rewards unlocked!'
                    : 'Need ${nextRewards.first.requiredXp - userProgress.xp} more XP to unlock',
                style: AppTextStyles.bodySmall,
              ),
            ] else ...[
              Text(
                'Congratulations! You\'ve unlocked all available rewards!',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.success,
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
  
  Widget _buildRewardCard(BuildContext context, Reward reward, bool isUnlocked) {
    return GestureDetector(
      onTap: isUnlocked ? () => _showRewardDetailDialog(context, reward) : null,
      child: Card(
        elevation: isUnlocked ? 4 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: isUnlocked ? Colors.white : Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: isUnlocked
                      ? reward.type.color.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  reward.type.icon,
                  color: isUnlocked ? reward.type.color : Colors.grey,
                  size: 30,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                reward.title,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isUnlocked ? AppColors.textPrimary : Colors.grey,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                isUnlocked ? 'Unlocked' : '${reward.requiredXp} XP required',
                style: AppTextStyles.bodySmall.copyWith(
                  color: isUnlocked ? AppColors.success : Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              if (!isUnlocked) ...[
                const SizedBox(height: 8),
                Icon(
                  Icons.lock,
                  color: Colors.grey,
                  size: 20,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  void _showRewardDetailDialog(BuildContext context, Reward reward) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(reward.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: reward.type.color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  reward.type.icon,
                  color: reward.type.color,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                reward.description,
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Type: ${reward.type.displayName}',
                style: AppTextStyles.bodySmall,
              ),
              Text(
                'Unlocked at ${reward.requiredXp} XP',
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
  
  void _showRewardUnlockedDialog(BuildContext context, Reward reward) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New Reward Unlocked!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: reward.type.color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  reward.type.icon,
                  color: reward.type.color,
                  size: 50,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                reward.title,
                style: AppTextStyles.heading3,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                reward.description,
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Awesome!'),
            ),
          ],
        );
      },
    );
  }
}
