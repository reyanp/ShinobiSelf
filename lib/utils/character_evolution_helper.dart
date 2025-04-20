import 'package:shinobi_self/models/user_preferences.dart';
import 'package:shinobi_self/models/user_progress.dart';
import 'package:shinobi_self/models/character_path.dart';

/// Helper class for character evolution unlocking logic
class CharacterEvolutionHelper {
  /// Get the list of unlocked character evolutions based on ninja rank
  static List<CharacterEvolution> getUnlockedEvolutions(NinjaRank ninjaRank) {
    switch (ninjaRank) {
      case NinjaRank.genin:
        return [CharacterEvolution.kid]; // Only kid version available for beginners
      case NinjaRank.chunin:
        return [CharacterEvolution.kid, CharacterEvolution.teen]; // Unlock teen at chunin
      case NinjaRank.jounin:
      case NinjaRank.hokage:
        // All versions unlocked for advanced ranks
        return [CharacterEvolution.kid, CharacterEvolution.teen, CharacterEvolution.adult];
      default:
        return [CharacterEvolution.kid]; // Default to kid version
    }
  }

  /// Check if a specific evolution is unlocked for the given rank
  static bool isEvolutionUnlocked(NinjaRank ninjaRank, CharacterEvolution evolution) {
    final unlockedEvolutions = getUnlockedEvolutions(ninjaRank);
    return unlockedEvolutions.contains(evolution);
  }

  /// Get the image path for the character based on character path and evolution stage
  static String getCharacterImagePath(CharacterPath? characterPath, CharacterEvolution evolution) {
    if (characterPath == null) {
      return 'assets/images/default_avatar.png'; // Fallback image
    }
    
    final characterName = characterPath.name.toLowerCase();
    
    // Handle special case for Sakura's kid image which is named "child" instead of "kid"
    if (characterPath == CharacterPath.sakura && evolution == CharacterEvolution.kid) {
      return 'assets/images/${characterName}_child.png';
    }
    
    return 'assets/images/${characterName}_${evolution.name}.png';
  }
  
  /// Get a user-friendly name for the evolution stage
  static String getEvolutionDisplayName(CharacterEvolution evolution) {
    switch (evolution) {
      case CharacterEvolution.kid:
        return 'Academy Student';
      case CharacterEvolution.teen:
        return 'Shinobi';
      case CharacterEvolution.adult:
        return 'Elite Ninja';
    }
  }
  
  /// Get the rank required to unlock a specific evolution
  static NinjaRank getRankRequiredForEvolution(CharacterEvolution evolution) {
    switch (evolution) {
      case CharacterEvolution.kid:
        return NinjaRank.genin; // Available from the start
      case CharacterEvolution.teen:
        return NinjaRank.chunin; // Requires Chunin rank
      case CharacterEvolution.adult:
        return NinjaRank.jounin; // Requires Jounin rank
    }
  }
}
