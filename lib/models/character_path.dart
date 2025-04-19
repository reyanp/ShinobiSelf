enum CharacterPath {
  naruto,
  sasuke,
  sakura,
}

class CharacterInfo {
  final CharacterPath path;
  final String name;
  final String description;
  final String imagePath;
  final List<String> traits;

  const CharacterInfo({
    required this.path,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.traits,
  });

  static const Map<CharacterPath, CharacterInfo> characters = {
    CharacterPath.naruto: CharacterInfo(
      path: CharacterPath.naruto,
      name: 'Naruto',
      description: 'Follow the path of social confidence and positivity. Like Naruto, you\'ll build resilience and a positive outlook through daily social challenges.',
      imagePath: 'assets/images/naruto.png',
      traits: ['Social Confidence', 'Positivity', 'Resilience', 'Determination'],
    ),
    CharacterPath.sasuke: CharacterInfo(
      path: CharacterPath.sasuke,
      name: 'Sasuke',
      description: 'Master discipline and focus on the Sasuke path. You\'ll develop mental strength and concentration through structured daily practices.',
      imagePath: 'assets/images/sasuke.png',
      traits: ['Discipline', 'Focus', 'Determination', 'Self-Control'],
    ),
    CharacterPath.sakura: CharacterInfo(
      path: CharacterPath.sakura,
      name: 'Sakura',
      description: 'Enhance emotional intelligence and self-reflection like Sakura. This path focuses on understanding emotions and building meaningful connections.',
      imagePath: 'assets/images/sakura.png',
      traits: ['Emotional Intelligence', 'Reflection', 'Empathy', 'Growth'],
    ),
  };
}
