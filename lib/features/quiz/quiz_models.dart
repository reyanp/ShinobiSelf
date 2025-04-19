import 'dart:math';

import 'package:shinobi_self/models/character_path.dart';

// Renamed to avoid conflict with the existing enum
// enum QuizPath { naruto, sasuke, sakura }

class AnswerOption {
  final String text;
  final CharacterPath path; // Use the existing enum

  const AnswerOption(this.text, this.path);
}

class Question {
  final String prompt;
  final List<AnswerOption> options;
  final String? // Optional image or visual element for the question
      imageUrl; 

  const Question({
    required this.prompt,
    required this.options,
    this.imageUrl,
  });

  /// Returns a fresh, shuffled copy of this question's options.
  List<AnswerOption> shuffledOptions() {
    // Ensure Random() is initialized if needed, or use default
    final random = Random(); 
    final copy = List<AnswerOption>.from(options);
    copy.shuffle(random);
    return copy;
  }
} 