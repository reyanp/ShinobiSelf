import 'package:flutter/material.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final String reward;
  final IconData icon;
  final bool isUnlocked;
  final bool isHidden; // Controls if the achievement details are hidden until unlocked

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.reward,
    required this.icon,
    this.isUnlocked = false,
    this.isHidden = false,
  });

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    String? reward,
    IconData? icon,
    bool? isUnlocked,
    bool? isHidden,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      reward: reward ?? this.reward,
      icon: icon ?? this.icon,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isHidden: isHidden ?? this.isHidden,
    );
  }
} 