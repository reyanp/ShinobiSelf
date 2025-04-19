import 'package:shinobi_self/models/character_path.dart';
import './quiz_models.dart';

final List<Question> allQuestions = <Question>[
  Question(
    prompt: 'When facing a tough obstacle, you tend to:',
    options: [
      AnswerOption('Never give up and push through with determination!', CharacterPath.naruto),
      AnswerOption('Analyze the situation calmly and find a logical solution.', CharacterPath.sasuke),
      AnswerOption('Seek support and advice from trusted friends or mentors.', CharacterPath.sakura),
    ],
    // imageUrl: 'assets/images/quiz_obstacle.png', // Example image path
  ),
  Question(
    prompt: 'In a team, your preferred role is:',
    options: [
      AnswerOption('The inspiring leader who motivates everyone.', CharacterPath.naruto),
      AnswerOption('The skilled specialist focused on achieving the goal efficiently.', CharacterPath.sasuke),
      AnswerOption('The supportive member ensuring harmony and well-being.', CharacterPath.sakura),
    ],
  ),
   Question(
    prompt: 'When someone disagrees with you, you usually:',
    options: [
      AnswerOption('Try hard to convince them of your viewpoint.', CharacterPath.naruto),
      AnswerOption('Present your reasoning clearly but respect their perspective.', CharacterPath.sasuke),
      AnswerOption('Listen carefully to understand their concerns and find common ground.', CharacterPath.sakura),
    ],
  ),
   Question(
    prompt: 'What drives you the most?',
    options: [
      AnswerOption('Protecting others and achieving recognition.', CharacterPath.naruto),
      AnswerOption('Mastering skills and gaining personal power/knowledge.', CharacterPath.sasuke),
      AnswerOption('Building strong relationships and helping those in need.', CharacterPath.sakura),
    ],
  ),
   Question(
    prompt: 'How do you typically handle strong emotions?',
    options: [
      AnswerOption('Channel them into action and determination.', CharacterPath.naruto),
      AnswerOption('Keep them controlled and focus on rationality.', CharacterPath.sasuke),
      AnswerOption('Acknowledge and process them, perhaps talking it through.', CharacterPath.sakura),
    ],
  ),
]; 