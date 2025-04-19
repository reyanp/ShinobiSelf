# Shinobi Self: Train Like a Ninja, Grow Like a Hero

A Naruto-themed mental wellness mobile app built with Flutter.

## Overview

Shinobi Self is a gamified mental wellness app that uses Naruto-style character paths, daily quests, XP progression, mood tracking, and rewards to help users improve their mental wellbeing.

## Features

### Character Selection
- Choose between Naruto, Sasuke, or Sakura paths during onboarding
- Each path focuses on different aspects of mental wellness:
  - **Naruto Path**: Social confidence & positivity
  - **Sasuke Path**: Discipline & focus
  - **Sakura Path**: Emotional intelligence & reflection

### Daily Missions
- 3 unique missions per day based on your chosen character path
- Examples:
  - **Naruto Path**: Compliment someone, Journal a proud moment, Smile in the mirror
  - **Sasuke Path**: Wake up before 8 AM, Avoid phone for 1 hour, Complete a focus session
  - **Sakura Path**: Reflect on a tough emotion, Text a friend to check in, Meditate

### Progress Tracking
- Earn XP by completing missions
- Level up through ninja ranks: Genin → Chunin → Jounin → Hokage
- Track daily streaks and total missions completed

### Mood Tracker
- Daily emoji-based mood check-in
- Naruto-themed feedback based on your mood
- View mood history and insights

### Rewards System
- Unlock quotes, stickers, and badges at XP milestones
- View your collection of unlocked rewards
- Track progress toward next reward

### Settings
- Change character path
- Manage app preferences
- Reset progress if needed

## Technical Implementation

### Architecture
- Feature-based architecture with clear separation of concerns
- Riverpod for state management
- Models for character paths, missions, user progress, moods, and rewards

### UI/UX
- Naruto-themed styling with chakra blue, orange, and silver colors
- Custom text styles and theme data
- Character-specific themes

### Data Management
- Local storage for user preferences and progress
- Firebase integration planned for authentication and cloud storage

## Getting Started

1. Ensure you have Flutter installed
2. Clone this repository
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to launch the app

## Future Enhancements

- Ninja SFX on quest complete & level up
- Daily "Hokage Wisdom" quotes
- Social sharing of achievements
- Expanded mission variety
- Community challenges

## Credits

Developed as a mental wellness app with Naruto-inspired theming and gamification elements.
