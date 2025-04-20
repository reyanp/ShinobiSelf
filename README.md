# Shinobi Self: Train Like a Ninja, Grow Like a Hero

A Naruto-themed mental wellness and self-improvement mobile app built with Flutter and Riverpod.

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-blue?logo=dart)](https://dart.dev)
[![Riverpod](https://img.shields.io/badge/Riverpod-2.x-blueviolet?logo=riverpod)](https://riverpod.dev)
[![OpenAI](https://img.shields.io/badge/OpenAI-API-green?logo=openai)](https://openai.com/)

## Overview

Shinobi Self is a gamified mental wellness and self-improvement app designed to help users build positive habits and resilience. Inspired by the world of Naruto, it uses character paths, daily and weekly missions, XP progression, ninja ranks, mood tracking, and achievements to make personal growth an engaging journey.

## Features

### Character Path Selection
-   Choose one of three distinct paths during onboarding:
    -   **Naruto Path**: Focuses on social confidence, optimism, and perseverance.
    -   **Sasuke Path**: Emphasizes discipline, focus, and skill development.
    -   **Sakura Path**: Centers on emotional intelligence, reflection, and inner strength.
-   Each path influences the types of missions generated.

### Missions & Challenges
-   **Daily Missions**:
    -   Receive a set of personalized missions each day, tailored to your chosen path.
    -   Includes both predefined missions and AI-generated missions using the OpenAI API for dynamic and relevant tasks.
    -   Option to manually generate additional AI missions.
-   **Weekly Challenges**:
    -   Larger, more rewarding missions that reset weekly, offering bigger XP gains.

### Progress & Gamification
-   **XP & Levels**: Earn Experience Points (XP) for completing missions and checking in your mood. Level up continuously.
-   **Ninja Ranks**: Progress through iconic ranks based on total XP: Genin → Chunin → Jounin → Hokage. Each rank has associated colors and milestones.
-   **Streaks**: Maintain a daily streak by completing all daily missions.
-   **Progress Screen**: A dedicated screen to visualize your rank, level, XP, progress towards the next rank, current streak, missions completed today, and total missions completed. Includes a recent activity history.

### Mood Tracking
-   Daily check-in using emoji-based mood selection (Sad, Okay, Good, Great, Amazing).
-   Earn XP for submitting your daily mood.
-   Track mood trends over time (future enhancement).

### Achievements
-   Unlock achievements for reaching milestones (e.g., completing a certain number of missions, reaching a specific rank, maintaining a streak).
-   View unlocked achievements in a dedicated section.

### Mission Completion Proof (Optional)
-   Optionally upload a photo as proof of mission completion for certain tasks.
-   Rate the mission experience.
-   Earn bonus XP for submitting proof.

### Settings
-   Customize accent color.
-   Manage app preferences.
-   (Planned: Change character path, Reset progress).

## Technical Implementation

### Architecture
-   **Feature-First**: Code organized by feature (home, progress, achievements, onboarding, etc.).
-   **Riverpod State Management**: Leverages Riverpod for dependency injection and reactive state management across the app (Providers, StateNotifiers, etc.).
-   **Models**: Clear data structures for `CharacterPath`, `Mission`, `UserProgress`, `MoodEntry`, `Achievement`, `UserPreferences`.
-   **Services**: Encapsulated logic for external interactions (e.g., `OpenAIService`, `MissionGeneratorService`).

### UI/UX
-   **Naruto Theming**: Custom color palettes (AppColors), text styles (AppTextStyles), and themed widgets reflecting the Naruto universe.
-   **Animations**: Subtle animations for engagement (e.g., header, mission cards).
-   **Responsive Design**: Adapts to different screen sizes.

### Key Technologies
-   **Flutter**: Cross-platform UI framework.
-   **Dart**: Programming language.
-   **Riverpod**: State management solution.
-   **OpenAI API**: For generating dynamic AI-powered missions.
-   **intl**: For date formatting.
-   **(Planned) Local Storage**: For persisting user data (e.g., `shared_preferences` or `hive`).
-   **(Planned) Firebase**: For potential cloud sync, authentication, or advanced features.

## Getting Started

1.  **Prerequisites**:
    *   Ensure you have Flutter (version 3.x or higher) and Dart installed.
    *   An OpenAI API key is required for AI mission generation.
2.  **Clone**: `git clone https://github.com/your-username/shinobi_self.git`
3.  **Navigate**: `cd shinobi_self`
4.  **Install Dependencies**: `flutter pub get`
5.  **Configure API Key**:
    *   Create a file: `lib/config/api_keys.dart`
    *   Add your OpenAI API key:
        ```dart
        // lib/config/api_keys.dart
        class ApiKeys {
          static const String openAI = 'YOUR_OPENAI_API_KEY';
        }
        ```
    *   **Important**: Add `lib/config/api_keys.dart` to your `.gitignore` file to avoid committing your key.
6.  **Run**: `flutter run`

## Presentation Talking Points

This section provides key points for presenting the Shinobi Self app:

1.  **Introduction & Vision**:
    *   **What**: Shinobi Self - A Naruto-inspired mobile app for mental wellness and self-improvement.
    *   **Why**: Gamification makes personal growth engaging and fun, leveraging the popular Naruto theme for motivation.
    *   **Goal**: Help users build positive habits, resilience, and self-awareness through daily actions.

2.  **Core Gameplay Loop**:
    *   **Onboarding**: User chooses a Character Path (Naruto, Sasuke, Sakura) aligning with their goals.
    *   **Daily Missions**: Receive tailored tasks (e.g., mindfulness, social interaction, discipline). Includes static and AI-generated missions via OpenAI.
    *   **Completion & Rewards**: Mark missions as complete, earn XP, potentially provide proof (image upload) for bonus XP.
    *   **Progression**: Gain XP -> Level Up -> Achieve higher Ninja Ranks (Genin to Hokage).
    *   **Tracking**: Monitor progress (rank, level, XP, streaks) on the Progress screen. Check achievements.
    *   **Consistency**: Daily Mood Check-in (earns XP) and maintaining Streaks encourage regular engagement.

3.  **Key Features Deep Dive**:
    *   **Character Paths**: Explain the different focuses (Social, Discipline, Emotional IQ) and how they influence missions.
    *   **AI Mission Generation**: Highlight the use of OpenAI to provide dynamic, personalized, and context-aware missions beyond a static list. Show the "Generate AI Mission" button.
    *   **Progress Screen**: Showcase the visual representation of rank, XP bar, stats (streak, missions today/total), and activity history.
    *   **Mood Tracker**: Simple, quick daily check-in reinforcing self-awareness.
    *   **Weekly Challenges**: Offer bigger goals and rewards for sustained effort.
    *   **Achievements**: Provide long-term goals and recognition for milestones.

4.  **Technical Highlights**:
    *   **Flutter**: Cross-platform development (mention if running on iOS/Android/Web).
    *   **Riverpod**: Explain its role in managing state cleanly and reactively (e.g., how completing a mission updates XP, level, rank, and progress screen automatically). Show provider examples if relevant (`userProgressProvider`, `dailyMissionsProvider`).
    *   **Feature-First Architecture**: How it keeps the codebase organized and scalable.
    *   **OpenAI Integration**: Briefly explain how prompts are constructed based on character path to get relevant missions (`MissionGeneratorService`).
    *   **Theming**: Custom `AppColors` and `AppTextStyles` for a consistent Naruto look and feel.

5.  **Future Directions**:
    *   Mention planned features: Local data persistence, sound effects, community features, expanded content (missions, achievements, rewards).
    *   Potential for more advanced AI integrations (e.g., personalized feedback based on mood history).

6.  **Q&A**: Be prepared to answer questions about specific features, technical choices, or the development process.

## Future Enhancements

-   **Persistence**: Implement local storage (`shared_preferences` or `hive`) to save user progress, preferences, and history.
-   **Sound Effects**: Add Ninja SFX for completing missions, leveling up, etc.
-   **Notifications**: Reminders for daily check-ins or new missions.
-   **Expanded Content**: More mission types, achievements, character-specific rewards.
-   **Community Features**: Leaderboards or shared challenges (requires backend/Firebase).
-   **Advanced Analytics**: Visualizations for mood trends or habit tracking.

## Credits

Developed with the aim of making mental wellness and self-improvement accessible and engaging through gamification and the motivating world of Naruto.
