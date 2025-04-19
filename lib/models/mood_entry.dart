import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shinobi_self/core/theme/app_colors.dart';
import 'package:shinobi_self/core/theme/app_text_styles.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

// Model for mood entries
class MoodEntry {
  final String id;
  final DateTime date;
  final MoodType mood;
  final String? note;

  MoodEntry({
    String? id,
    required this.date,
    required this.mood,
    this.note,
  }) : id = id ?? const Uuid().v4();
}

// Enum for different mood types
enum MoodType {
  terrible,
  bad,
  okay,
  good,
  great
}

// Extension to get mood-related data
extension MoodTypeExtension on MoodType {
  String get emoji {
    switch (this) {
      case MoodType.terrible: return '😢';
      case MoodType.bad: return '😐';
      case MoodType.okay: return '🙂';
      case MoodType.good: return '😄';
      case MoodType.great: return '🤩';
    }
  }
  
  String get label {
    switch (this) {
      case MoodType.terrible: return 'Sad';
      case MoodType.bad: return 'Okay';
      case MoodType.okay: return 'Good';
      case MoodType.good: return 'Great';
      case MoodType.great: return 'Amazing';
    }
  }
  
  Color get color {
    switch (this) {
      case MoodType.terrible: return Colors.red.shade300;
      case MoodType.bad: return Colors.orange.shade300;
      case MoodType.okay: return Colors.yellow.shade300;
      case MoodType.good: return Colors.lightGreen.shade300;
      case MoodType.great: return Colors.green.shade300;
    }
  }
  
  String get narutoPhraseForMood {
    switch (this) {
      case MoodType.terrible:
        return "Even Naruto had his down days. Remember, it's through pain that we grow stronger.";
      case MoodType.bad:
        return "As Kakashi would say, 'In the ninja world, those who break the rules are scum, but those who abandon their friends are worse than scum.' Reach out if you need support.";
      case MoodType.okay:
        return "You're doing alright! As Naruto says, 'I'm not gonna run away, I never go back on my word! That's my nindo: my ninja way!'";
      case MoodType.good:
        return "Great job! Like Naruto's Shadow Clone Jutsu, you're multiplying your positive energy today!";
      case MoodType.great:
        return "Amazing! You're shining brighter than Naruto in Nine-Tails Chakra Mode today!";
    }
  }
}

// Provider for mood entries
final moodEntriesProvider = StateProvider<List<MoodEntry>>((ref) {
  // In a real app, this would be loaded from a database
  return [
    MoodEntry(
      date: DateTime.now().subtract(const Duration(days: 1)),
      mood: MoodType.good,
      note: "Had a productive day and completed all my missions!",
    ),
    MoodEntry(
      date: DateTime.now().subtract(const Duration(days: 2)),
      mood: MoodType.okay,
      note: "Feeling a bit tired but still managed to stay positive.",
    ),
    MoodEntry(
      date: DateTime.now().subtract(const Duration(days: 3)),
      mood: MoodType.great,
      note: "Amazing day! Everything went well and I felt very energetic.",
    ),
    MoodEntry(
      date: DateTime.now().subtract(const Duration(days: 4)),
      mood: MoodType.bad,
      note: "Struggled with focus today, but tomorrow is a new day.",
    ),
    MoodEntry(
      date: DateTime.now().subtract(const Duration(days: 5)),
      mood: MoodType.okay,
      note: "Average day, nothing special but not bad either.",
    ),
  ];
});

// Provider for selected mood
final selectedMoodProvider = StateProvider<MoodType?>((ref) => null);

// Provider for mood note
final moodNoteProvider = StateProvider<String>((ref) => "");

// Provider to check if today's mood has been logged
final hasTodaysMoodProvider = Provider<bool>((ref) {
  final entries = ref.watch(moodEntriesProvider);
  final today = DateTime.now();
  return entries.any((entry) => 
    entry.date.year == today.year && 
    entry.date.month == today.month && 
    entry.date.day == today.day
  );
});
