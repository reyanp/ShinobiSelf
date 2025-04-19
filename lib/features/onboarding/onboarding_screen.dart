import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shinobi_self/models/character_path.dart';
import 'package:shinobi_self/models/user_preferences.dart';
import 'package:shinobi_self/core/theme/app_colors.dart';
import 'package:shinobi_self/core/theme/app_text_styles.dart';
import 'package:shinobi_self/features/quiz/quiz_screen.dart';

// Provider for storing the selected character path
final selectedCharacterProvider = StateProvider<CharacterPath?>((ref) => null);

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  CharacterPath? _recommendedPath;
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _buildPages().length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      final selectedPath = ref.read(selectedCharacterProvider);
      if (selectedPath != null) {
        ref.read(userPrefsProvider.notifier).completeOnboarding(selectedPath);
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a character path')),
        );
      }
    }
  }

  Future<void> _takeQuiz() async {
    final result = await Navigator.push<CharacterPath?>(
      context,
      MaterialPageRoute(builder: (context) => const QuizScreen()),
    );

    if (result != null) {
      ref.read(selectedCharacterProvider.notifier).state = result;
      setState(() {
        _recommendedPath = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedPath = ref.watch(selectedCharacterProvider);
    final totalPages = _buildPages().length;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: _buildPages(),
              ),
            ),
            _buildNavigationControls(selectedPath, totalPages),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPages() {
    return [
      _buildWelcomePage(),
      _buildPathSelectionPage(),
      _buildConfirmationPage(),
    ];
  }

  Widget _buildWelcomePage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Text(
            'Shinobi Self',
            style: AppTextStyles.heading1.copyWith(
              color: AppColors.chakraBlue,
              fontSize: 32,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Train Like a Ninja, Grow Like a Hero',
            style: AppTextStyles.heading3.copyWith(
              color: AppColors.narutoOrange,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              color: AppColors.silverGray.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.self_improvement,
                size: 120,
                color: AppColors.chakraBlue,
              ),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            'Welcome to your mental wellness journey inspired by the world of Naruto!',
            style: AppTextStyles.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Complete daily missions, track your progress, and level up from Genin to Hokage!',
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPathSelectionPage() {
    final selectedPath = ref.watch(selectedCharacterProvider);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Choose Your Path', style: AppTextStyles.heading2, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          Text(
            'Select a path that resonates with you, or take the quiz for a recommendation.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            icon: const Icon(Icons.psychology),
            label: const Text('Find My Path (Quiz)'),
            onPressed: _takeQuiz,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
          const SizedBox(height: 20),
          if (_recommendedPath != null && selectedPath == _recommendedPath)
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Text(
                '✨ Recommended path selected! ✨',
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
              ),
            ),
          ...CharacterPath.values.map((path) {
            final character = CharacterInfo.characters[path]!;
            final isSelected = selectedPath == path;
            return _buildPathCard(character, path, isSelected);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildPathCard(CharacterInfo character, CharacterPath path, bool isSelected) {
    return Card(
      elevation: isSelected ? 4 : 1,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? _getPathColor(path) : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          ref.read(selectedCharacterProvider.notifier).state = path;
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: _getPathColor(path).withOpacity(0.1),
                child: Text(
                  character.name[0],
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _getPathColor(path)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      character.name,
                      style: AppTextStyles.heading3.copyWith(color: _getPathColor(path)),
                    ),
                    Text(
                      character.traits.join(' • '),
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                    Text(
                      character.description,
                      style: AppTextStyles.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (isSelected) Icon(Icons.check_circle, color: _getPathColor(path), size: 28),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmationPage() {
    final selectedPath = ref.watch(selectedCharacterProvider);
    if (selectedPath == null) {
      return const Center(child: Text('Please go back and select a path.'));
    }
    final character = CharacterInfo.characters[selectedPath]!;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Path Confirmed', style: AppTextStyles.heading2, textAlign: TextAlign.center),
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundColor: _getPathColor(selectedPath).withOpacity(0.1),
            child: Text(
              character.name[0],
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: _getPathColor(selectedPath)),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'You have chosen the path of ${character.name}!',
            style: AppTextStyles.heading3.copyWith(color: _getPathColor(selectedPath)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            character.description,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLarge,
          ),
          const SizedBox(height: 24),
          Text(
            'Begin your training and unlock your potential.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationControls(CharacterPath? selectedPath, int totalPages) {
    final isLastPage = _currentPage == totalPages - 1;
    final canProceed = _currentPage != 1 || selectedPath != null;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentPage > 0)
            TextButton(onPressed: () => _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut), child: const Text('Back'))
          else
            const SizedBox(width: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalPages, (index) {
              return Container(
                width: 10, height: 10,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index ? Theme.of(context).primaryColor : AppColors.divider,
                ),
              );
            }),
          ),
          ElevatedButton(
            onPressed: canProceed ? _nextPage : null,
            child: Text(isLastPage ? 'Finish' : 'Next'),
          ),
        ],
      ),
    );
  }

  Color _getPathColor(CharacterPath path) {
    switch (path) {
      case CharacterPath.naruto:
        return AppColors.narutoPathColor;
      case CharacterPath.sasuke:
        return AppColors.sasukePathColor;
      case CharacterPath.sakura:
        return AppColors.sakuraPathColor;
    }
  }
}
