import 'dart:math';
import 'package:shinobi_self/models/character_path.dart';
import 'package:shinobi_self/models/mission.dart';
import 'package:shinobi_self/services/openai_service.dart';

class MissionGeneratorService {
  static final Random _random = Random();
  
  // Define trait weights by character path
  static Map<String, double> getTraitWeights(CharacterPath characterPath) {
    // All traits with default weight
    final Map<String, double> weights = {
      'Social Confidence': 3.0,
      'Positivity': 3.0,
      'Resilience': 3.0,
      'Determination': 3.0,
      'Discipline': 3.0,
      'Focus': 3.0,
      'Self-Control': 3.0,
      'Emotional Intelligence': 3.0,
      'Reflection': 3.0,
      'Empathy': 3.0,
      'Growth': 3.0,
    };
    
    // Get character info
    final characterInfo = CharacterInfo.characters[characterPath]!;
    
    // Increase weights for the traits of the selected character
    for (String trait in characterInfo.traits) {
      weights[trait] = 5.0;
    }
    
    return weights;
  }
  
  // Select a random trait based on weights
  static String selectWeightedRandomTrait(CharacterPath characterPath) {
    final weights = getTraitWeights(characterPath);
    final totalWeight = weights.values.reduce((sum, weight) => sum + weight);
    
    // Generate a random value between 0 and totalWeight
    double randomValue = _random.nextDouble() * totalWeight;
    
    // Find the selected trait
    double currentSum = 0;
    for (var entry in weights.entries) {
      currentSum += entry.value;
      if (randomValue <= currentSum) {
        return entry.key;
      }
    }
    
    // Fallback (should never reach here unless weights map is empty)
    return weights.keys.first;
  }
  
  // Generate a mission using OpenAI based on selected trait
  static Future<Mission?> generateAIMission(CharacterPath characterPath) async {
    try {
      // Select a random trait based on weights
      final selectedTrait = selectWeightedRandomTrait(characterPath);
      
      // Get character info
      final characterInfo = CharacterInfo.characters[characterPath]!;
      
      // Generate mission content using OpenAI
      final missionContent = await OpenAIService.generateMission(
        selectedTrait,
        characterInfo.name,
      );
      
      if (missionContent == null) {
        return null;
      }
      
      // Parse the generated content - expecting a two-line response
      // Line 1: Title
      // Line 2: Description
      final lines = missionContent.trim().split('\n');
      
      String title;
      String description;
      
      if (lines.length >= 2) {
        // Proper format with title and description on separate lines
        title = _formatTitle(lines[0].trim());
        description = _cleanDescription(lines[1].trim());
      } else {
        // Fallback if we don't get two lines
        final parts = missionContent.trim().split('.');
        if (parts.length > 1) {
          title = _formatTitle(parts[0].trim());
          description = _cleanDescription(parts.sublist(1).join('.').trim());
        } else {
          title = _formatTitle(missionContent.trim());
          description = "Complete this mission to improve your skills.";
        }
      }
      
      // Create a new mission
      final mission = Mission(
        title: title,
        description: description,
        xpReward: 50, // Standard XP reward for AI-generated missions
        type: _getMissionTypeForTrait(characterPath, selectedTrait),
        frequency: MissionFrequency.daily,
      );
      
      return mission;
    } catch (e) {
      print('Error generating AI mission: $e');
      return null;
    }
  }
  
  // Format title with asterisks and proper capitalization
  static String _formatTitle(String title) {
    // Clean the title
    String cleaned = title.trim()
        .replaceAll(RegExp(r'^\d+\.\s*'), '') // Remove numbering
        .replaceAll(RegExp(r'\*\*'), '') // Remove any existing asterisks
        .replaceFirst(RegExp(r'^[A-Za-z]+:\s*'), ''); // Remove "Mission:" or similar prefixes
    
    // Return formatted title with asterisks
    return "$cleaned";
  }
  
  // Helper method to clean and format the description
  static String _cleanDescription(String description) {
    final cleaned = description.trim()
        .replaceAll(RegExp(r'^\.\s*'), '') // Remove leading periods
        .replaceAll(RegExp(r'^\d+\.\s*'), ''); // Remove numbering
    
    // Ensure the first letter is capitalized and there's a period at the end
    if (cleaned.isEmpty) return "Complete this mission to improve your skills.";
    
    String result = cleaned;
    if (result.isNotEmpty) {
      result = result[0].toUpperCase() + result.substring(1);
      if (!result.endsWith('.') && !result.endsWith('!') && !result.endsWith('?')) {
        result += '.';
      }
    }
    
    return result;
  }
  
  // Determine the mission type based on character path and trait
  static MissionType _getMissionTypeForTrait(CharacterPath characterPath, String trait) {
    switch (characterPath) {
      case CharacterPath.naruto:
        if (trait == 'Social Confidence') return MissionType.narutoSocial;
        if (trait == 'Positivity') return MissionType.narutoPositivity;
        return MissionType.narutoSocial;
      
      case CharacterPath.sasuke:
        if (trait == 'Discipline') return MissionType.sasukeDiscipline;
        if (trait == 'Focus') return MissionType.sasukeFocus;
        return MissionType.sasukeDiscipline;
      
      case CharacterPath.sakura:
        if (trait == 'Emotional Intelligence') return MissionType.sakuraEmotional;
        if (trait == 'Reflection') return MissionType.sakuraReflection;
        return MissionType.sakuraEmotional;
    }
  }
  
  // Generate a batch of initial missions
  static Future<List<Mission>> generateInitialMissions(CharacterPath characterPath, int count) async {
    List<Mission> missions = [];
    
    // Generate the requested number of missions
    for (int i = 0; i < count; i++) {
      try {
        final mission = await generateAIMission(characterPath);
        
        if (mission != null) {
          missions.add(mission);
        }
        
        // Add a small delay to ensure different traits are selected
        await Future.delayed(const Duration(milliseconds: 100));
      } catch (e) {
        print('Error generating initial mission $i: $e');
      }
    }
    
    return missions;
  }
} 