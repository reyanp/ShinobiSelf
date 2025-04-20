import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shinobi_self/core/animations/animation_helpers.dart';
import 'package:shinobi_self/core/theme/app_colors.dart';
import 'package:shinobi_self/core/theme/app_text_styles.dart';
import 'package:shinobi_self/models/character_path.dart';
import 'package:shinobi_self/models/user_progress.dart';
import 'package:shinobi_self/models/user_preferences.dart';
import 'package:shinobi_self/utils/character_evolution_helper.dart';

class AnimatedUserHeader extends ConsumerStatefulWidget {
  final CharacterInfo characterInfo;
  final int userXp;
  final int userStreak;
  final Color userAccentColor;

  const AnimatedUserHeader({
    Key? key,
    required this.characterInfo,
    required this.userXp,
    required this.userStreak,
    required this.userAccentColor,
  }) : super(key: key);

  @override
  ConsumerState<AnimatedUserHeader> createState() => _AnimatedUserHeaderState();
}

class _AnimatedUserHeaderState extends ConsumerState<AnimatedUserHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _progressAnimation;

  // Store previous XP to animate progress bar
  int _previousXp = 0;
  double _animationProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _previousXp = widget.userXp;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation =
        Tween<double>(begin: 0.9, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    ));

    _progressAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
    ));

    // Start the animation after a short delay
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void didUpdateWidget(AnimatedUserHeader oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Animate XP changes
    if (widget.userXp != oldWidget.userXp) {
      _previousXp = oldWidget.userXp;
      _animationProgress = 0.0;

      // Trigger animation
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final ninjaRank = _getNinjaRank(widget.userXp);
    final nextRankXp = _getNextRankXp(widget.userXp);
    final progress = widget.userXp / nextRankXp;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Interpolate between previous and current XP for smooth animation
        final animatedXp = _previousXp +
            (widget.userXp - _previousXp) * _progressAnimation.value;
        final animatedProgress = animatedXp / nextRankXp;

        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ShimmerEffect(
                          animate: widget.userStreak > 2,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: _getPathColor(widget.characterInfo.path)
                                  .withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: ClipOval(
                                child: Image.asset(
                                  // Use the selected profile image from user preferences
                                  CharacterEvolutionHelper.getCharacterImagePath(
                                    widget.characterInfo.path,
                                    ref.watch(userPrefsProvider).selectedProfileImage,
                                  ),
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    // Fallback to the first letter if image fails to load
                                    return Text(
                                      widget.characterInfo.name[0],
                                      style: AppTextStyles.heading1.copyWith(
                                        color: _getPathColor(
                                            widget.characterInfo.path),
                                      ),
                                    );
                                  },
                                ),
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
                                '${widget.characterInfo.name} Path',
                                style: AppTextStyles.heading3.copyWith(
                                  color:
                                      _getPathColor(widget.characterInfo.path),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Ninja Rank: $ninjaRank',
                                style: AppTextStyles.ninjaRank.copyWith(
                                  color: _getRankColor(ninjaRank),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            PulseAnimator(
                              animate: widget.userStreak > 0,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.local_fire_department,
                                    color: AppColors.narutoOrange,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${widget.userStreak} day${widget.userStreak != 1 ? 's' : ''} streak',
                                    style: AppTextStyles.streakCounter,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.stars,
                                  color: widget.userAccentColor,
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.userXp} XP',
                                  style: AppTextStyles.xpCounter.copyWith(
                                    color: widget.userAccentColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Progress to ${_getNextRank(ninjaRank)}',
                              style: isDarkMode
                                  ? AppTextStyles.toDarkMode(
                                      AppTextStyles.bodySmall)
                                  : AppTextStyles.bodySmall,
                            ),
                            Text(
                              '${animatedXp.toInt()} / $nextRankXp XP',
                              style: isDarkMode
                                  ? AppTextStyles.toDarkMode(
                                      AppTextStyles.bodySmall)
                                  : AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Stack(
                          children: [
                            // Background progress bar
                            Container(
                              height: 10,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? Colors.grey[800]
                                    : AppColors.divider,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            // Animated progress
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 800),
                              curve: Curves.easeOutCubic,
                              height: 10,
                              width: MediaQuery.of(context).size.width *
                                  animatedProgress *
                                  0.8, // Adjust for padding
                              decoration: BoxDecoration(
                                color: _getRankColor(ninjaRank),
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    color: _getRankColor(ninjaRank)
                                        .withOpacity(0.5),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _getNinjaRank(int xp) {
    if (xp >= 2000) return 'Hokage';
    if (xp >= 1000) return 'Jounin';
    if (xp >= 500) return 'Chunin';
    return 'Genin';
  }

  String _getNextRank(String currentRank) {
    switch (currentRank) {
      case 'Genin':
        return 'Chunin';
      case 'Chunin':
        return 'Jounin';
      case 'Jounin':
        return 'Hokage';
      default:
        return 'Hokage';
    }
  }

  int _getNextRankXp(int currentXp) {
    if (currentXp < 500) return 500;
    if (currentXp < 1000) return 1000;
    if (currentXp < 2000) return 2000;
    return 3000; // Beyond Hokage
  }

  Color _getPathColor(CharacterPath path) {
    switch (path) {
      case CharacterPath.naruto:
        return AppColors.narutoOrange;
      case CharacterPath.sasuke:
        return AppColors.sasukePurple;
      case CharacterPath.sakura:
        return AppColors.sakuraPink;
    }
  }

  Color _getRankColor(String rank) {
    switch (rank) {
      case 'Genin':
        return AppColors.geninColor;
      case 'Chunin':
        return AppColors.chuninColor;
      case 'Jounin':
        return AppColors.jouninColor;
      case 'Hokage':
        return AppColors.hokageColor;
      default:
        return AppColors.chakraBlue;
    }
  }
}
