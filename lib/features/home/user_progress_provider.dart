import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shinobi_self/models/user_progress.dart';
import 'package:shinobi_self/models/ninja_rank.dart';
import 'package:shinobi_self/models/user_preferences.dart';

// NOTE: This file only contains STUB providers to allow the dialog to compile
// These are not the real providers used in the app
// The real providers are defined in their respective model files

// Stub provider for user progress data - only for dialog implementation
final dialogUserProgressProvider = StateProvider<UserProgress>((ref) {
  // Return a default UserProgress instance
  return UserProgress(
    xp: 0,
    level: 1,
    rank: NinjaRank.genin,
    completedMissions: 0, 
    totalMissionsCompleted: 0,
    streak: 0,
  );
});

// Define a provider for user preferences 
// (This is likely defined elsewhere but is referenced in HomeDashboard)
final userPrefsProvider = StateProvider<UserPreferences>((ref) {
  return UserPreferences();
}); 