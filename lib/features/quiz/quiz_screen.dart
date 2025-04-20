import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shinobi_self/features/quiz/quiz_models.dart';
import 'package:shinobi_self/features/quiz/quiz_questions.dart';
import 'package:shinobi_self/models/character_path.dart';
import 'package:shinobi_self/core/theme/app_colors.dart'; // For colors
import 'package:shinobi_self/core/theme/app_text_styles.dart'; // For text styles
import 'package:shinobi_self/models/user_preferences.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  late final List<Question> _questions;
  late final List<List<AnswerOption>> _shuffledAnswers;
  final Map<CharacterPath, int> _scores = {
    CharacterPath.naruto: 0,
    CharacterPath.sasuke: 0,
    CharacterPath.sakura: 0,
  };
  int _currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();
    // Shuffle the order of questions themselves
    _questions = List<Question>.from(allQuestions)..shuffle();
    // Generate shuffled answers for each question
    _shuffledAnswers = _questions.map((q) => q.shuffledOptions()).toList();
  }

  void _answerQuestion(CharacterPath path) {
    setState(() {
      _scores[path] = (_scores[path] ?? 0) + 1;
      _currentQuestionIndex++;
    });
  }

  CharacterPath _calculateRecommendation() {
    // Find the path with the highest score
    CharacterPath recommendedPath = CharacterPath.naruto; // Default
    int maxScore = -1;
    _scores.forEach((path, score) {
      if (score > maxScore) {
        maxScore = score;
        recommendedPath = path;
      } else if (score == maxScore) {
        // Handle ties - could randomize, default, or let user pick later
        // For simplicity, let's keep the first one encountered (or default)
      }
    });
    return recommendedPath;
  }

  @override
  Widget build(BuildContext context) {
    final bool quizComplete = _currentQuestionIndex >= _questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(quizComplete ? 'Quiz Results' : 'Path Finding Quiz'),
        automaticallyImplyLeading: !quizComplete, // No back button on results
      ),
      body: quizComplete
          ? _buildResultsScreen(context)
          : _buildQuestionScreen(context),
    );
  }

  Widget _buildQuestionScreen(BuildContext context) {
    final question = _questions[_currentQuestionIndex];
    final options = _shuffledAnswers[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / _questions.length;
    // Check if we're in dark mode
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 24),
          Text(
            'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
            style: isDarkMode
                ? AppTextStyles.toDarkMode(
                    Theme.of(context).textTheme.labelSmall!)
                : Theme.of(context).textTheme.labelSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            question.prompt,
            style: isDarkMode
                ? AppTextStyles.toDarkMode(
                        Theme.of(context).textTheme.headlineSmall!)
                    .copyWith(fontWeight: FontWeight.bold)
                : Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          // Optional: Display image if question.imageUrl is not null
          // if (question.imageUrl != null) ...[
          //   const SizedBox(height: 20),
          //   Image.asset(question.imageUrl!, height: 150),
          // ],
          const SizedBox(height: 32),
          Expanded(
            child: ListView.separated(
              itemCount: options.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (ctx, i) {
                final opt = options[i];
                return ElevatedButton(
                  onPressed: () => _answerQuestion(opt.path),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                    textStyle: Theme.of(context).textTheme.titleMedium,
                  ),
                  child: Text(opt.text, textAlign: TextAlign.center),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsScreen(BuildContext context) {
    // Get the notifier using ref.read since we are inside a ConsumerState
    final userPrefsNotifier = ref.read(userPrefsProvider.notifier);
    final recommendedPath = _calculateRecommendation();
    final pathInfo = CharacterInfo.characters[recommendedPath]!;
    // Check if we're in dark mode
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Determine color based on path for visual flair
    Color pathColor;
    switch (recommendedPath) {
      case CharacterPath.naruto:
        pathColor = AppColors.narutoPathColor;
        break;
      case CharacterPath.sasuke:
        pathColor = AppColors.sasukePathColor;
        break;
      case CharacterPath.sakura:
        pathColor = AppColors.sakuraPathColor;
        break;
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Recommendation:',
            style: isDarkMode
                ? AppTextStyles.darkModeTextSecondary.copyWith(fontSize: 16)
                : Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'The ${pathInfo.name} Path',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: pathColor,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            'Based on your answers, this path seems like a great fit for your personality and goals. '
            '(${pathInfo.description})',
            style: isDarkMode
                ? AppTextStyles.toDarkMode(
                    Theme.of(context).textTheme.bodyLarge!)
                : Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Text(
            'You can always change your path later in settings.',
            style: isDarkMode
                ? AppTextStyles.darkModeTextSecondary
                : Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            icon: const Icon(Icons.check_circle_outline),
            label: Text('Start with the ${pathInfo.name} Path'),
            style: ElevatedButton.styleFrom(backgroundColor: pathColor),
            onPressed: () {
              // Complete onboarding with the recommended path
              userPrefsNotifier.completeOnboarding(recommendedPath);
              // Navigate to home screen, removing onboarding from stack
              Navigator.pushNamedAndRemoveUntil(
                  context, '/home', (route) => false);
            },
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            icon: const Icon(Icons.list_alt),
            label: const Text('Let me choose manually'),
            onPressed: () {
              // Return null to indicate manual choice
              Navigator.pop(context, null);
            },
          ),
        ],
      ),
    );
  }
}
