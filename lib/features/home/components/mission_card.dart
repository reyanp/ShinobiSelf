import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shinobi_self/core/animations/animation_helpers.dart';
import 'package:shinobi_self/core/animations/confetti_overlay.dart';
import 'package:shinobi_self/core/theme/app_colors.dart';
import 'package:shinobi_self/core/theme/app_text_styles.dart';
import 'package:shinobi_self/models/mission.dart';
import 'package:shinobi_self/models/user_preferences.dart';

class AnimatedMissionCard extends ConsumerStatefulWidget {
  final Mission mission;
  final Function(Mission) onComplete;

  const AnimatedMissionCard({
    Key? key,
    required this.mission,
    required this.onComplete,
  }) : super(key: key);

  @override
  ConsumerState<AnimatedMissionCard> createState() =>
      _AnimatedMissionCardState();
}

class _AnimatedMissionCardState extends ConsumerState<AnimatedMissionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _opacityAnimation;
  bool _showConfetti = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _slideAnimation = Tween<double>(
      begin: 50,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    // Delay the animation slightly when first appearing
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleComplete() {
    setState(() {
      _showConfetti = true;
    });

    // Call the parent's onComplete callback
    widget.onComplete(widget.mission);

    // Hide confetti after a delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showConfetti = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final userAccentColor = ref.watch(userPrefsProvider).accentColor;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: child,
          ),
        );
      },
      child: ConfettiOverlay(
        showConfetti: _showConfetti,
        child: Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: widget.mission.isCompleted ? 1 : 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: widget.mission.isCompleted
                  ? Colors.transparent
                  : userAccentColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.mission.title,
                        style: widget.mission.isCompleted
                            ? (isDarkMode
                                ? AppTextStyles.toDarkMode(
                                        AppTextStyles.questTitle)
                                    .copyWith(
                                        decoration: TextDecoration.lineThrough)
                                : AppTextStyles.questTitle.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: AppColors.textSecondary,
                                  ))
                            : (isDarkMode
                                ? AppTextStyles.toDarkMode(
                                    AppTextStyles.questTitle)
                                : AppTextStyles.questTitle),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: userAccentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '+${widget.mission.xpReward} XP',
                        style: AppTextStyles.xpCounter.copyWith(
                          color: userAccentColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  widget.mission.description,
                  style: widget.mission.isCompleted
                      ? (isDarkMode
                          ? AppTextStyles.toDarkMode(
                                  AppTextStyles.questDescription)
                              .copyWith(decoration: TextDecoration.lineThrough)
                          : AppTextStyles.questDescription.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: AppColors.textSecondary,
                            ))
                      : (isDarkMode
                          ? AppTextStyles.toDarkMode(
                              AppTextStyles.questDescription)
                          : AppTextStyles.questDescription),
                ),
                const SizedBox(height: 16),
                ScaleButton(
                  onTap: widget.mission.isCompleted ? null : _handleComplete,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: widget.mission.isCompleted
                          ? (isDarkMode
                              ? Colors.grey[700]
                              : AppColors.silverGray)
                          : userAccentColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: widget.mission.isCompleted
                          ? null
                          : [
                              BoxShadow(
                                color: userAccentColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            widget.mission.isCompleted
                                ? Icons.check_circle
                                : Icons.check_circle_outline,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.mission.isCompleted
                                ? 'Completed'
                                : 'Mark as Complete',
                            style: AppTextStyles.buttonMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
