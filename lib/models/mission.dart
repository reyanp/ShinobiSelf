import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:shinobi_self/models/character_path.dart';

enum MissionFrequency {
  daily,
  weekly,
}

class Mission {
  final String id;
  final String title;
  final String description;
  final int xpReward;
  final bool isCompleted;
  final DateTime? completedAt;
  final MissionType type;
  final MissionFrequency frequency;
  final DateTime resetTime;

  Mission({
    String? id,
    required this.title,
    required this.description,
    required this.xpReward,
    this.isCompleted = false,
    this.completedAt,
    required this.type,
    required this.frequency,
    DateTime? resetTime,
  }) : id = id ?? const Uuid().v4(),
       resetTime = resetTime ?? _calculateResetTime(frequency);

  Mission copyWith({
    String? id,
    String? title,
    String? description,
    int? xpReward,
    bool? isCompleted,
    DateTime? completedAt,
    MissionType? type,
    MissionFrequency? frequency,
    DateTime? resetTime,
  }) {
    return Mission(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      xpReward: xpReward ?? this.xpReward,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      type: type ?? this.type,
      frequency: frequency ?? this.frequency,
      resetTime: resetTime ?? this.resetTime,
    );
  }

  bool get shouldReset {
    final now = DateTime.now();
    return now.isAfter(resetTime);
  }

  static DateTime _calculateResetTime(MissionFrequency frequency) {
    final now = DateTime.now();
    
    switch (frequency) {
      case MissionFrequency.daily:
        // Reset at midnight
        return DateTime(now.year, now.month, now.day + 1);
      case MissionFrequency.weekly:
        // Reset on Sunday at midnight
        final daysUntilSunday = DateTime.sunday - now.weekday;
        final nextSunday = daysUntilSunday <= 0 
          ? now.add(Duration(days: 7 + daysUntilSunday)) 
          : now.add(Duration(days: daysUntilSunday));
        return DateTime(nextSunday.year, nextSunday.month, nextSunday.day);
    }
  }
}

enum MissionType {
  narutoSocial,
  narutoPositivity,
  narutoResilience,
  sasukeDiscipline,
  sasukeFocus,
  sasukeControl,
  sakuraEmotional,
  sakuraReflection,
  sakuraEmpathy,
}

class MissionData {
  static List<Mission> getNarutoMissions({MissionFrequency? frequency}) {
    final missions = [
      Mission(
        title: 'Compliment Someone',
        description: 'Give a genuine compliment to someone today. Notice how it makes both of you feel.',
        xpReward: 50,
        type: MissionType.narutoSocial,
        frequency: MissionFrequency.daily,
      ),
      Mission(
        title: 'Journal a Proud Moment',
        description: 'Write down something you\'re proud of accomplishing today, no matter how small.',
        xpReward: 40,
        type: MissionType.narutoPositivity,
        frequency: MissionFrequency.daily,
      ),
      Mission(
        title: 'Smile in the Mirror',
        description: 'Stand in front of a mirror and smile for 60 seconds. Notice how it affects your mood.',
        xpReward: 30,
        type: MissionType.narutoPositivity,
        frequency: MissionFrequency.daily,
      ),
      Mission(
        title: 'Start a Conversation',
        description: 'Initiate a conversation with someone new or someone you don\'t talk to often.',
        xpReward: 50,
        type: MissionType.narutoSocial,
        frequency: MissionFrequency.daily,
      ),
      Mission(
        title: 'Practice Gratitude',
        description: 'List three things you\'re grateful for today.',
        xpReward: 40,
        type: MissionType.narutoPositivity,
        frequency: MissionFrequency.daily,
      ),
      // Weekly Missions
      Mission(
        title: 'Host a Social Gathering',
        description: 'Organize a small get-together with friends or family.',
        xpReward: 100,
        type: MissionType.narutoSocial,
        frequency: MissionFrequency.weekly,
      ),
      Mission(
        title: 'Inspire Others',
        description: 'Share your personal growth story with someone who might benefit from hearing it.',
        xpReward: 80,
        type: MissionType.narutoPositivity,
        frequency: MissionFrequency.weekly,
      ),
    ];

    if (frequency != null) {
      return missions.where((m) => m.frequency == frequency).toList();
    }
    return missions;
  }

  static List<Mission> getSasukeMissions({MissionFrequency? frequency}) {
    final missions = [
      Mission(
        title: 'Wake Up Before 8 AM',
        description: 'Start your day early to maximize productivity and focus.',
        xpReward: 50,
        type: MissionType.sasukeDiscipline,
        frequency: MissionFrequency.daily,
      ),
      Mission(
        title: 'Avoid Phone for 1 Hour',
        description: 'Put your phone away and focus on a task without distractions for one hour.',
        xpReward: 60,
        type: MissionType.sasukeFocus,
        frequency: MissionFrequency.daily,
      ),
      Mission(
        title: 'Complete a Focus Session',
        description: 'Dedicate 10 minutes to a task with complete focus, no distractions.',
        xpReward: 40,
        type: MissionType.sasukeFocus,
        frequency: MissionFrequency.daily,
      ),
      Mission(
        title: 'Create a Daily Plan',
        description: 'Write down your top 3 priorities for the day and stick to them.',
        xpReward: 40,
        type: MissionType.sasukeDiscipline,
        frequency: MissionFrequency.daily,
      ),
      Mission(
        title: 'Physical Training',
        description: 'Complete a short workout or stretching session to build discipline.',
        xpReward: 50,
        type: MissionType.sasukeControl,
        frequency: MissionFrequency.daily,
      ),
      // Weekly Missions
      Mission(
        title: 'Master a New Skill',
        description: 'Spend dedicated time learning something new and challenging.',
        xpReward: 100,
        type: MissionType.sasukeDiscipline,
        frequency: MissionFrequency.weekly,
      ),
      Mission(
        title: 'Complete a Major Task',
        description: 'Finish an important project or task you\'ve been putting off.',
        xpReward: 90,
        type: MissionType.sasukeFocus,
        frequency: MissionFrequency.weekly,
      ),
    ];

    if (frequency != null) {
      return missions.where((m) => m.frequency == frequency).toList();
    }
    return missions;
  }

  static List<Mission> getSakuraMissions({MissionFrequency? frequency}) {
    final missions = [
      Mission(
        title: 'Reflect on a Tough Emotion',
        description: 'Take time to identify and process a difficult emotion you experienced today.',
        xpReward: 50,
        type: MissionType.sakuraEmotional,
        frequency: MissionFrequency.daily,
      ),
      Mission(
        title: 'Text a Friend to Check In',
        description: 'Reach out to a friend or family member to see how they\'re doing.',
        xpReward: 40,
        type: MissionType.sakuraEmpathy,
        frequency: MissionFrequency.daily,
      ),
      Mission(
        title: 'Meditate for 5 Minutes',
        description: 'Take 5 minutes to sit quietly, focus on your breath, and clear your mind.',
        xpReward: 50,
        type: MissionType.sakuraReflection,
        frequency: MissionFrequency.daily,
      ),
      Mission(
        title: 'Practice Active Listening',
        description: 'In your next conversation, focus entirely on listening without planning your response.',
        xpReward: 40,
        type: MissionType.sakuraEmpathy,
        frequency: MissionFrequency.daily,
      ),
      Mission(
        title: 'Identify Your Triggers',
        description: 'Reflect on what situations trigger negative emotions for you and why.',
        xpReward: 50,
        type: MissionType.sakuraEmotional,
        frequency: MissionFrequency.daily,
      ),
      // Weekly Missions
      Mission(
        title: 'Deep Emotional Check-In',
        description: 'Journal about your emotional growth and patterns from the past week.',
        xpReward: 100,
        type: MissionType.sakuraReflection,
        frequency: MissionFrequency.weekly,
      ),
      Mission(
        title: 'Support Someone in Need',
        description: 'Offer meaningful support to someone going through a difficult time.',
        xpReward: 90,
        type: MissionType.sakuraEmpathy,
        frequency: MissionFrequency.weekly,
      ),
    ];

    if (frequency != null) {
      return missions.where((m) => m.frequency == frequency).toList();
    }
    return missions;
  }

  static List<Mission> getMissionsForCharacterPath(
    CharacterPath path, {
    MissionFrequency? frequency,
  }) {
    switch (path) {
      case CharacterPath.naruto:
        return getNarutoMissions(frequency: frequency);
      case CharacterPath.sasuke:
        return getSasukeMissions(frequency: frequency);
      case CharacterPath.sakura:
        return getSakuraMissions(frequency: frequency);
    }
  }

  static List<Mission> getDailyMissions(CharacterPath path) {
    final allMissions = getMissionsForCharacterPath(path, frequency: MissionFrequency.daily);
    allMissions.shuffle();
    return allMissions.take(3).toList();
  }

  static List<Mission> getWeeklyMissions(CharacterPath path) {
    final allMissions = getMissionsForCharacterPath(path, frequency: MissionFrequency.weekly);
    allMissions.shuffle();
    return allMissions.take(2).toList();
  }
}
