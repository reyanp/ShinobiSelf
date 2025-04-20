import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shinobi_self/core/theme/app_colors.dart';
import 'package:shinobi_self/core/theme/app_text_styles.dart';
import 'package:shinobi_self/models/user_preferences.dart';
import 'package:shinobi_self/models/user_progress.dart';
import 'package:shinobi_self/models/character_path.dart';
import 'package:shinobi_self/utils/character_evolution_helper.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPrefs = ref.watch(userPrefsProvider);
    final userProgress = ref.watch(userProgressProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Get the character path
    final characterPath = userPrefs.characterPath;
    if (characterPath == null) {
      // Handle case where character path is not set (should not happen in normal flow)
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(child: Text('Character not selected. Please complete onboarding.')),
      );
    }
    
    // Get character info
    final characterInfo = CharacterInfo.characters[characterPath]!;
    
    // Get unlocked evolutions based on ninja rank
    final unlockedEvolutions = CharacterEvolutionHelper.getUnlockedEvolutions(userProgress.rank);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ninja Profile'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile header with current avatar
            _buildProfileHeader(context, characterPath, userPrefs.selectedProfileImage, userProgress),
            
            const SizedBox(height: 24),
            
            // Character evolution section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Character Evolution',
                    style: isDarkMode 
                        ? AppTextStyles.toDarkMode(AppTextStyles.heading2)
                        : AppTextStyles.heading2,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Unlock new character forms as you rank up!',
                    style: isDarkMode
                        ? AppTextStyles.toDarkMode(AppTextStyles.bodyMedium)
                        : AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  
                  // Character evolution options
                  _buildEvolutionOptions(
                    context, 
                    ref, 
                    characterPath, 
                    unlockedEvolutions, 
                    userPrefs.selectedProfileImage,
                    userProgress.rank,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Character stats section
            _buildCharacterStats(context, userProgress, characterInfo),
          ],
        ),
      ),
    );
  }
  
  Widget _buildProfileHeader(
    BuildContext context, 
    CharacterPath characterPath,
    CharacterEvolution selectedEvolution,
    UserProgress userProgress,
  ) {
    final characterInfo = CharacterInfo.characters[characterPath]!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _getPathColor(characterPath).withOpacity(0.8),
            _getPathColor(characterPath).withOpacity(0.2),
          ],
        ),
      ),
      child: Column(
        children: [
          // Character avatar
          Hero(
            tag: 'profile_avatar',
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white,
              backgroundImage: AssetImage(
                CharacterEvolutionHelper.getCharacterImagePath(characterPath, selectedEvolution),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Character name and rank
          Text(
            characterInfo.name,
            style: AppTextStyles.heading1.copyWith(
              color: isDarkMode ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            userProgress.rank.displayName,
            style: AppTextStyles.heading3.copyWith(
              color: isDarkMode ? Colors.white70 : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          
          // XP and level
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatChip(
                context, 
                'Level ${userProgress.level}', 
                Icons.trending_up,
              ),
              const SizedBox(width: 16),
              _buildStatChip(
                context, 
                '${userProgress.xp} XP', 
                Icons.star,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatChip(BuildContext context, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEvolutionOptions(
    BuildContext context,
    WidgetRef ref,
    CharacterPath characterPath,
    List<CharacterEvolution> unlockedEvolutions,
    CharacterEvolution selectedEvolution,
    NinjaRank currentRank,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: CharacterEvolution.values.length,
      itemBuilder: (context, index) {
        final evolution = CharacterEvolution.values[index];
        final isUnlocked = unlockedEvolutions.contains(evolution);
        final isSelected = evolution == selectedEvolution;
        
        return _buildEvolutionCard(
          context,
          ref,
          characterPath,
          evolution,
          isUnlocked,
          isSelected,
        );
      },
    );
  }
  
  Widget _buildEvolutionCard(
    BuildContext context,
    WidgetRef ref,
    CharacterPath characterPath,
    CharacterEvolution evolution,
    bool isUnlocked,
    bool isSelected,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: isUnlocked 
          ? () => ref.read(userPrefsProvider.notifier).updateProfileImage(evolution)
          : () => _showUnlockRequirementsDialog(context, evolution),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected 
              ? _getPathColor(characterPath).withOpacity(0.2)
              : isDarkMode ? Colors.grey[800] : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? _getPathColor(characterPath)
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Character image
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white.withOpacity(0.8),
                  backgroundImage: isUnlocked
                      ? AssetImage(CharacterEvolutionHelper.getCharacterImagePath(characterPath, evolution))
                      : null,
                  child: isUnlocked 
                      ? null
                      : Icon(Icons.lock, color: Colors.grey[600], size: 30),
                ),
                if (isSelected)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: _getPathColor(characterPath),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Evolution name
            Text(
              CharacterEvolutionHelper.getEvolutionDisplayName(evolution),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isUnlocked
                    ? (isDarkMode ? Colors.white : Colors.black87)
                    : Colors.grey,
              ),
            ),
            
            // Unlock requirement
            if (!isUnlocked)
              Text(
                'Unlock at ${CharacterEvolutionHelper.getRankRequiredForEvolution(evolution).displayName}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  void _showUnlockRequirementsDialog(BuildContext context, CharacterEvolution evolution) {
    final requiredRank = CharacterEvolutionHelper.getRankRequiredForEvolution(evolution);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Evolution Locked'),
        content: Text(
          'You need to reach the rank of ${requiredRank.displayName} to unlock the ${CharacterEvolutionHelper.getEvolutionDisplayName(evolution)} evolution.'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCharacterStats(
    BuildContext context, 
    UserProgress userProgress,
    CharacterInfo characterInfo,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Character Stats',
            style: isDarkMode 
                ? AppTextStyles.toDarkMode(AppTextStyles.heading2)
                : AppTextStyles.heading2,
          ),
          const SizedBox(height: 16),
          
          // Stats cards
          _buildStatCard(
            context,
            'Missions Completed',
            userProgress.totalMissionsCompleted.toString(),
            Icons.task_alt,
          ),
          const SizedBox(height: 12),
          _buildStatCard(
            context,
            'Current Streak',
            '${userProgress.streak} days',
            Icons.local_fire_department,
          ),
          const SizedBox(height: 12),
          _buildStatCard(
            context,
            'Character Path',
            characterInfo.name,
            Icons.route,
          ),
          const SizedBox(height: 12),
          _buildStatCard(
            context,
            'Traits',
            characterInfo.traits.join(', '),
            Icons.psychology,
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatCard(
    BuildContext context, 
    String title, 
    String value, 
    IconData icon,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.chakraBlue),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Color _getPathColor(CharacterPath path) {
    switch (path) {
      case CharacterPath.naruto:
        return AppColors.narutoOrange;
      case CharacterPath.sasuke:
        return AppColors.chakraBlue;
      case CharacterPath.sakura:
        return AppColors.chakraRed;
      default:
        return AppColors.chakraBlue; // Default fallback
    }
  }
}
