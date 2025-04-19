import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shinobi_self/core/theme/app_colors.dart';
import 'package:shinobi_self/models/user_progress.dart';
import 'package:uuid/uuid.dart';

// Model for rewards
class Reward {
  final String id;
  final String title;
  final String description;
  final RewardType type;
  final String assetPath;
  final int requiredXp;
  final bool isUnlocked;

  Reward({
    String? id,
    required this.title,
    required this.description,
    required this.type,
    required this.assetPath,
    required this.requiredXp,
    this.isUnlocked = false,
  }) : id = id ?? const Uuid().v4();

  Reward copyWith({
    String? id,
    String? title,
    String? description,
    RewardType? type,
    String? assetPath,
    int? requiredXp,
    bool? isUnlocked,
  }) {
    return Reward(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      assetPath: assetPath ?? this.assetPath,
      requiredXp: requiredXp ?? this.requiredXp,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }
}

// Enum for different reward types
enum RewardType {
  quote,
  sticker,
  badge,
}

// Extension to get reward-related data
extension RewardTypeExtension on RewardType {
  String get displayName {
    switch (this) {
      case RewardType.quote:
        return 'Quote';
      case RewardType.sticker:
        return 'Sticker';
      case RewardType.badge:
        return 'Badge';
    }
  }

  IconData get icon {
    switch (this) {
      case RewardType.quote:
        return Icons.format_quote;
      case RewardType.sticker:
        return Icons.emoji_emotions;
      case RewardType.badge:
        return Icons.military_tech;
    }
  }

  Color get color {
    switch (this) {
      case RewardType.quote:
        return AppColors.chakraBlue;
      case RewardType.sticker:
        return AppColors.narutoOrange;
      case RewardType.badge:
        return AppColors.hokageColor;
    }
  }
}

// Provider for rewards
final rewardsProvider = StateProvider<List<Reward>>((ref) {
  // In a real app, this would be loaded from a database
  return [
    // Quotes
    Reward(
      title: 'Naruto\'s Determination',
      description: '"I\'m not gonna run away, I never go back on my word! That\'s my nindo: my ninja way!"',
      type: RewardType.quote,
      assetPath: 'assets/images/naruto_quote.png',
      requiredXp: 100,
    ),
    Reward(
      title: 'Kakashi\'s Wisdom',
      description: '"In the ninja world, those who break the rules are scum, but those who abandon their friends are worse than scum."',
      type: RewardType.quote,
      assetPath: 'assets/images/kakashi_quote.png',
      requiredXp: 200,
    ),
    Reward(
      title: 'Itachi\'s Insight',
      description: '"People live their lives bound by what they accept as correct and true... that is how they define reality."',
      type: RewardType.quote,
      assetPath: 'assets/images/itachi_quote.png',
      requiredXp: 300,
    ),
    Reward(
      title: 'Jiraiya\'s Legacy',
      description: '"A person grows up when they can overcome their past."',
      type: RewardType.quote,
      assetPath: 'assets/images/jiraiya_quote.png',
      requiredXp: 400,
    ),
    Reward(
      title: 'Gaara\'s Transformation',
      description: '"The longer you live... The more you realize that reality is just made of pain, suffering and emptiness."',
      type: RewardType.quote,
      assetPath: 'assets/images/gaara_quote.png',
      requiredXp: 500,
    ),
    
    // Stickers
    Reward(
      title: 'Naruto Thumbs Up',
      description: 'A motivational sticker of Naruto giving a thumbs up!',
      type: RewardType.sticker,
      assetPath: 'assets/images/naruto_thumbs_up.png',
      requiredXp: 150,
    ),
    Reward(
      title: 'Sasuke Smirk',
      description: 'A cool sticker of Sasuke with his signature smirk.',
      type: RewardType.sticker,
      assetPath: 'assets/images/sasuke_smirk.png',
      requiredXp: 250,
    ),
    Reward(
      title: 'Sakura Power',
      description: 'A sticker of Sakura showing her incredible strength!',
      type: RewardType.sticker,
      assetPath: 'assets/images/sakura_power.png',
      requiredXp: 350,
    ),
    Reward(
      title: 'Kakashi Reading',
      description: 'A sticker of Kakashi reading his favorite book.',
      type: RewardType.sticker,
      assetPath: 'assets/images/kakashi_reading.png',
      requiredXp: 450,
    ),
    Reward(
      title: 'Ramen Time',
      description: 'A sticker of Naruto enjoying his favorite ramen!',
      type: RewardType.sticker,
      assetPath: 'assets/images/naruto_ramen.png',
      requiredXp: 550,
    ),
    
    // Badges
    Reward(
      title: 'First Mission Complete',
      description: 'Completed your first mission!',
      type: RewardType.badge,
      assetPath: 'assets/images/first_mission_badge.png',
      requiredXp: 50,
    ),
    Reward(
      title: 'Chunin Rank Achieved',
      description: 'Reached the Chunin rank!',
      type: RewardType.badge,
      assetPath: 'assets/images/chunin_badge.png',
      requiredXp: 500,
    ),
    Reward(
      title: 'Jounin Rank Achieved',
      description: 'Reached the Jounin rank!',
      type: RewardType.badge,
      assetPath: 'assets/images/jounin_badge.png',
      requiredXp: 1000,
    ),
    Reward(
      title: 'Hokage Rank Achieved',
      description: 'Reached the Hokage rank!',
      type: RewardType.badge,
      assetPath: 'assets/images/hokage_badge.png',
      requiredXp: 2000,
    ),
    Reward(
      title: '7-Day Streak',
      description: 'Maintained a 7-day streak!',
      type: RewardType.badge,
      assetPath: 'assets/images/streak_badge.png',
      requiredXp: 700,
    ),
  ];
});

// Service for managing rewards
class RewardsService {
  // Update rewards based on user progress
  static List<Reward> updateRewards(List<Reward> rewards, UserProgress progress) {
    return rewards.map((reward) {
      if (!reward.isUnlocked && progress.xp >= reward.requiredXp) {
        return reward.copyWith(isUnlocked: true);
      }
      return reward;
    }).toList();
  }
  
  // Get newly unlocked rewards
  static List<Reward> getNewlyUnlockedRewards(List<Reward> oldRewards, List<Reward> newRewards) {
    return newRewards.where((newReward) {
      final oldReward = oldRewards.firstWhere((r) => r.id == newReward.id, orElse: () => newReward);
      return newReward.isUnlocked && !oldReward.isUnlocked;
    }).toList();
  }
  
  // Get all unlocked rewards
  static List<Reward> getUnlockedRewards(List<Reward> rewards) {
    return rewards.where((reward) => reward.isUnlocked).toList();
  }
  
  // Get all locked rewards
  static List<Reward> getLockedRewards(List<Reward> rewards) {
    return rewards.where((reward) => !reward.isUnlocked).toList();
  }
  
  // Get rewards by type
  static List<Reward> getRewardsByType(List<Reward> rewards, RewardType type) {
    return rewards.where((reward) => reward.type == type).toList();
  }
  
  // Get next rewards to unlock
  static List<Reward> getNextRewardsToUnlock(List<Reward> rewards, int currentXp) {
    final lockedRewards = getLockedRewards(rewards);
    if (lockedRewards.isEmpty) return [];
    
    // Sort by required XP
    lockedRewards.sort((a, b) => a.requiredXp.compareTo(b.requiredXp));
    
    // Find the next XP threshold
    int nextXpThreshold = lockedRewards.first.requiredXp;
    
    // Return all rewards at that threshold
    return lockedRewards.where((reward) => reward.requiredXp == nextXpThreshold).toList();
  }
}
