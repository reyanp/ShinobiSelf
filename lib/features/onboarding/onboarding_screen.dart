import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shinobi_self/models/character_path.dart';
import 'package:shinobi_self/core/theme/app_colors.dart';
import 'package:shinobi_self/core/theme/app_text_styles.dart';

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
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                children: [
                  _buildWelcomePage(),
                  _buildCharacterSelectionPage(),
                ],
              ),
            ),
            _buildPageIndicator(),
            _buildBottomButton(),
          ],
        ),
      ),
    );
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

  Widget _buildCharacterSelectionPage() {
    final selectedCharacter = ref.watch(selectedCharacterProvider);
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Text(
            'Choose Your Ninja Path',
            style: AppTextStyles.heading2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Select the character whose path resonates with your goals',
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              children: CharacterPath.values.map((path) {
                final character = CharacterInfo.characters[path]!;
                final isSelected = selectedCharacter == path;
                
                return GestureDetector(
                  onTap: () {
                    ref.read(selectedCharacterProvider.notifier).state = path;
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected 
                            ? _getPathColor(path) 
                            : AppColors.divider,
                        width: isSelected ? 2 : 1,
                      ),
                      color: isSelected 
                          ? _getPathColor(path).withOpacity(0.1) 
                          : Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: _getPathColor(path).withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                character.name[0],
                                style: AppTextStyles.heading1.copyWith(
                                  color: _getPathColor(path),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  character.name,
                                  style: AppTextStyles.heading3.copyWith(
                                    color: _getPathColor(path),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  character.traits.join(' • '),
                                  style: AppTextStyles.bodySmall,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  character.description,
                                  style: AppTextStyles.bodySmall,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: _getPathColor(path),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
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

  Widget _buildPageIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [0, 1].map((index) {
          return Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentPage == index
                  ? AppColors.chakraBlue
                  : AppColors.silverGray,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBottomButton() {
    final selectedCharacter = ref.watch(selectedCharacterProvider);
    final bool isLastPage = _currentPage == 1;
    final bool canProceed = !isLastPage || selectedCharacter != null;
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: ElevatedButton(
        onPressed: canProceed
            ? () {
                if (_currentPage < 1) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else {
                  // Navigate to home screen
                  Navigator.pushReplacementNamed(context, '/home');
                }
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: canProceed ? AppColors.chakraBlue : AppColors.silverGray,
          minimumSize: const Size(double.infinity, 56),
        ),
        child: Text(
          isLastPage ? 'Begin Your Journey' : 'Next',
          style: AppTextStyles.buttonLarge,
        ),
      ),
    );
  }
}
