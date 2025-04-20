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

## Working Functionalities

All of the following features are fully functional:

- ✅ **Character Selection & Onboarding**: Complete character path selection with themed UI
- ✅ **Daily Missions**: Generation and tracking of character-specific missions
- ✅ **XP System**: Earn XP from completing missions and tracking mood
- ✅ **Rank Progression**: Level up through ninja ranks with visual feedback
- ✅ **Mood Tracking**: Daily mood check-ins with history and insights
- ✅ **Achievement System**: Unlock achievements based on progress
- ✅ **Theme Customization**: Light/dark mode and accent color options
- ✅ **Animated Backgrounds**: Toggle subtle animations for enhanced experience
- ✅ **Sound Effects**: Character-specific sounds when completing missions
- ✅ **Android Back Navigation**: Modern back gesture support

## Presentation Points

### Architecture Overview
1. **Feature-Based Structure**
   - Organized by features (onboarding, home, missions, mood, achievements)
   - Clear separation of concerns with models, services, and UI components

2. **State Management**
   - Uses Riverpod for reactive state management
   - StateProvider and StateNotifierProvider for different state complexities
   - Consistent state update patterns across the app

3. **Theme System**
   - Character-specific theming with shared color palette
   - Dark/light mode support with contextual UI elements
   - Accent color customization persists across sessions

### Key Implementation Features
1. **Character System**
   - Character paths affect available missions and feedback
   - Character evolution ties to progression system
   - Path-specific sound effects enhance immersion

2. **Mission System**
   - Daily mission generation based on character path
   - XP rewards for completion with bonus for evidence
   - Mission reset logic for new days

3. **Progress & Achievement System**
   - Level calculation based on XP thresholds
   - Rank progression (Genin → Chunin → Jounin → Hokage)
   - Achievements tied to meaningful milestones

4. **UI Innovations**
   - Animated components for user feedback
   - Path-specific styling throughout the app
   - Responsive design works across device sizes

5. **Animation & Sound System**
   - Subtle animations enhance the experience
   - Character-specific sound effects for completion
   - Performance-optimized animations

## Testing Checklist

### Core Features
- [ ] App launches successfully without crashes
- [ ] Onboarding flow completes with character selection
- [ ] Navigation between tabs works smoothly
- [ ] Android back navigation functions correctly

### User Path & Missions
- [ ] Character path selection affects available missions
- [ ] Daily missions display correctly
- [ ] Mission completion awards XP
- [ ] Evidence submission works (optional for missions)
- [ ] Mission reset occurs appropriately

### Progress System
- [ ] XP accumulates correctly from missions
- [ ] Level updates based on XP thresholds
- [ ] Rank progression works (Genin → Chunin → Jounin → Hokage)
- [ ] Progress screen displays accurate stats
- [ ] Streaks increment and reset as expected

### Mood Tracker
- [ ] Daily mood check-in works
- [ ] Mood history displays correctly
- [ ] Mood insights show accurate data
- [ ] Mood submission awards XP
- [ ] Naruto-themed feedback appears for moods

### Achievement System
- [ ] Achievements unlock based on progress
- [ ] Achievement screen displays all achievements
- [ ] Locked/unlocked state persists across sessions
- [ ] Achievement unlocking provides feedback

### Settings & Customization
- [ ] Theme mode toggles (light/dark) work
- [ ] Accent color selection applies throughout app
- [ ] Animated background toggle works
- [ ] Sound effects toggle works
- [ ] Reset progress function works

### Performance & Polish
- [ ] Animations run smoothly
- [ ] Sound effects play correctly
- [ ] No visual glitches in UI
- [ ] App responsiveness on different screen sizes
- [ ] State persistence across app restarts

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
- Sound effects and animated backgrounds fully implemented

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
