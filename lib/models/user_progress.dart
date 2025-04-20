import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shinobi_self/core/theme/app_colors.dart';
import 'package:shinobi_self/core/theme/app_text_styles.dart';
import 'package:shinobi_self/models/user_preferences.dart';

// Provider for user progress data
final userProgressProvider = StateProvider<UserProgress>((ref) {
  return UserProgress(
    xp: 0,
    level: 1,
    rank: NinjaRank.genin,
    streak: 0,
    completedMissions: 0,
    totalMissionsCompleted: 0,
  );
});

class UserProgress {
  final int xp;
  final int level;
  final NinjaRank rank;
  final int streak;
  final int completedMissions; // Today's completed missions
  final int totalMissionsCompleted; // All-time completed missions
  final DateTime? lastStreakUpdateDate; // Date when streak was last updated

  UserProgress({
    required this.xp,
    required this.level,
    required this.rank,
    required this.streak,
    required this.completedMissions,
    required this.totalMissionsCompleted,
    this.lastStreakUpdateDate,
  });

  UserProgress copyWith({
    int? xp,
    int? level,
    NinjaRank? rank,
    int? streak,
    int? completedMissions,
    int? totalMissionsCompleted,
    DateTime? lastStreakUpdateDate,
  }) {
    return UserProgress(
      xp: xp ?? this.xp,
      level: level ?? this.level,
      rank: rank ?? this.rank,
      streak: streak ?? this.streak,
      completedMissions: completedMissions ?? this.completedMissions,
      totalMissionsCompleted:
          totalMissionsCompleted ?? this.totalMissionsCompleted,
      lastStreakUpdateDate: lastStreakUpdateDate ?? this.lastStreakUpdateDate,
    );
  }
}

enum NinjaRank {
  genin(requiredXp: 0, displayName: 'Genin', color: AppColors.geninColor),
  chunin(requiredXp: 500, displayName: 'Chunin', color: AppColors.chuninColor),
  jounin(requiredXp: 1000, displayName: 'Jounin', color: AppColors.jouninColor),
  hokage(requiredXp: 2000, displayName: 'Hokage', color: AppColors.hokageColor);

  const NinjaRank({
    required this.requiredXp,
    required this.displayName,
    required this.color,
  });

  final int requiredXp;
  final String displayName;
  final Color color;

  NinjaRank get nextRank {
    if (this == hokage) return hokage; // Already max rank
    return NinjaRank.values[index + 1];
  }
}

extension NinjaRankExtension on NinjaRank {
  String get displayName {
    switch (this) {
      case NinjaRank.genin:
        return 'Genin';
      case NinjaRank.chunin:
        return 'Chunin';
      case NinjaRank.jounin:
        return 'Jounin';
      case NinjaRank.hokage:
        return 'Hokage';
    }
  }

  Color get color {
    switch (this) {
      case NinjaRank.genin:
        return AppColors.geninColor;
      case NinjaRank.chunin:
        return AppColors.chuninColor;
      case NinjaRank.jounin:
        return AppColors.jouninColor;
      case NinjaRank.hokage:
        return AppColors.hokageColor;
    }
  }

  NinjaRank get nextRank {
    switch (this) {
      case NinjaRank.genin:
        return NinjaRank.chunin;
      case NinjaRank.chunin:
        return NinjaRank.jounin;
      case NinjaRank.jounin:
        return NinjaRank.hokage;
      case NinjaRank.hokage:
        return NinjaRank.hokage; // Already at max rank
    }
  }

  int get requiredXp {
    switch (this) {
      case NinjaRank.genin:
        return 500; // XP needed to reach Chunin
      case NinjaRank.chunin:
        return 1000; // XP needed to reach Jounin
      case NinjaRank.jounin:
        return 2000; // XP needed to reach Hokage
      case NinjaRank.hokage:
        return 3000; // Beyond Hokage (for continued progress)
    }
  }
}

class ProgressService {
  // Add XP and update rank if necessary
  static UserProgress addXp(UserProgress progress, int xpToAdd) {
    final newXp = progress.xp + xpToAdd;
    final currentRank = progress.rank;

    // Check if rank should be updated
    NinjaRank newRank = currentRank;
    if (currentRank != NinjaRank.hokage && newXp >= currentRank.requiredXp) {
      newRank = currentRank.nextRank;
    }

    // Calculate level (1 level per 100 XP)
    final newLevel = (newXp / 100).floor() + 1;

    return progress.copyWith(
      xp: newXp,
      rank: newRank,
      level: newLevel,
    );
  }

  // Update streak when all daily missions are completed
  static UserProgress updateStreak(UserProgress progress) {
    return progress.copyWith(
      streak: progress.streak + 1,
    );
  }

  // Reset streak when a day is missed
  static UserProgress resetStreak(UserProgress progress) {
    return progress.copyWith(
      streak: 0,
    );
  }

  // Mark a mission as completed
  static UserProgress completeMission(UserProgress progress) {
    return progress.copyWith(
      completedMissions: progress.completedMissions + 1,
      totalMissionsCompleted: progress.totalMissionsCompleted + 1,
    );
  }

  // Reset daily completed missions count (called at the start of a new day)
  static UserProgress resetDailyMissions(UserProgress progress) {
    return progress.copyWith(
      completedMissions: 0,
    );
  }
}
