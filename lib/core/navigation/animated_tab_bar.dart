import 'package:flutter/material.dart';
import 'package:shinobi_self/core/theme/app_colors.dart';

class AnimatedTabBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<AnimatedTabItem> items;
  final Color activeColor;
  final Color backgroundColor;

  const AnimatedTabBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.activeColor = AppColors.narutoOrange,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  @override
  State<AnimatedTabBar> createState() => _AnimatedTabBarState();
}

class _AnimatedTabBarState extends State<AnimatedTabBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(widget.items.length, (index) {
          final isSelected = widget.currentIndex == index;

          return _buildTabItem(
            item: widget.items[index],
            isSelected: isSelected,
            onTap: () => widget.onTap(index),
          );
        }),
      ),
    );
  }

  Widget _buildTabItem({
    required AnimatedTabItem item,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? widget.activeColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              transform: Matrix4.identity()
                ..translate(0.0, isSelected ? -4.0 : 0.0, 0.0),
              child: Icon(
                item.icon,
                color:
                    isSelected ? widget.activeColor : AppColors.textSecondary,
                size: isSelected ? 28 : 24,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color:
                    isSelected ? widget.activeColor : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: isSelected ? 14 : 12,
              ),
              child: Text(item.label),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedTabItem {
  final IconData icon;
  final String label;

  const AnimatedTabItem({
    required this.icon,
    required this.label,
  });
}
