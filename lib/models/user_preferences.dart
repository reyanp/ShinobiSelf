import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shinobi_self/models/character_path.dart';
import 'package:shinobi_self/core/theme/app_colors.dart'; // For default accent
import 'dart:convert'; // For jsonEncode/Decode
import 'package:uuid/uuid.dart'; // For generating IDs

// Enum for Sound Packs
enum SoundPack { naruto, traditional, nature }

// Model for a single reminder setting
class ReminderSetting {
  final String id;
  final TimeOfDay time;
  final String message;
  final bool isEnabled;

  ReminderSetting({
    String? id, // Allow providing ID, generate if null
    required this.time,
    required this.message,
    this.isEnabled = true,
  }) : id = id ?? const Uuid().v4();

  // copyWith method
  ReminderSetting copyWith({
    String? id,
    TimeOfDay? time,
    String? message,
    bool? isEnabled,
  }) {
    return ReminderSetting(
      id: id ?? this.id,
      time: time ?? this.time,
      message: message ?? this.message,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() => {
        'id': id,
        // Store time as minutes since midnight for easy serialization
        'timeMinutes': time.hour * 60 + time.minute,
        'message': message,
        'isEnabled': isEnabled,
      };

  // fromJson method
  factory ReminderSetting.fromJson(Map<String, dynamic> json) {
    final minutes = json['timeMinutes'] as int;
    return ReminderSetting(
      id: json['id'] as String,
      time: TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60),
      message: json['message'] as String,
      isEnabled: json['isEnabled'] as bool,
    );
  }
}


// Enum for character evolution stages
enum CharacterEvolution { kid, teen, adult }

class UserPreferences {
  final CharacterPath? characterPath;
  final bool hasCompletedOnboarding;
  final ThemeMode themeMode;
  final Color accentColor;
  final bool useAnimatedBackground;
  final SoundPack soundPack;
  final List<ReminderSetting> reminders;
  final CharacterEvolution selectedProfileImage; // New field for profile image selection

  const UserPreferences({
    this.characterPath,
    this.hasCompletedOnboarding = false,
    this.themeMode = ThemeMode.system, // Default to system theme
    this.accentColor = AppColors.chakraBlue, // Default accent
    this.useAnimatedBackground = true,
    this.soundPack = SoundPack.naruto, // Default sound pack
    this.reminders = const [],
    this.selectedProfileImage = CharacterEvolution.kid, // Default to kid version
  });

  UserPreferences copyWith({
    CharacterPath? characterPath,
    bool? hasCompletedOnboarding,
    ThemeMode? themeMode,
    Color? accentColor,
    bool? useAnimatedBackground,
    SoundPack? soundPack,
    List<ReminderSetting>? reminders,
    CharacterEvolution? selectedProfileImage,
    // Handle potential null characterPath if needed during copyWith
    bool clearCharacterPath = false,
  }) {
    return UserPreferences(
      characterPath: clearCharacterPath ? null : characterPath ?? this.characterPath,
      hasCompletedOnboarding: hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      themeMode: themeMode ?? this.themeMode,
      accentColor: accentColor ?? this.accentColor,
      useAnimatedBackground: useAnimatedBackground ?? this.useAnimatedBackground,
      soundPack: soundPack ?? this.soundPack,
      reminders: reminders ?? this.reminders,
      selectedProfileImage: selectedProfileImage ?? this.selectedProfileImage,
    );
  }
}

// --- State Notifier Provider for User Preferences ---

final userPrefsProvider = StateNotifierProvider<UserPreferencesNotifier, UserPreferences>((ref) {
  return UserPreferencesNotifier();
});

class UserPreferencesNotifier extends StateNotifier<UserPreferences> {
  UserPreferencesNotifier() : super(const UserPreferences()) {
    _loadPreferences();
  }

  static const _themeModeKey = 'themeMode';
  static const _accentColorKey = 'accentColor';
  static const _animatedBgKey = 'animatedBackground';
  static const _soundPackKey = 'soundPack';
  static const _onboardingKey = 'onboardingCompleted';
  static const _characterPathKey = 'characterPath';
  static const _remindersKey = 'remindersList'; // Key for reminders
  static const _profileImageKey = 'profileImage'; // Key for profile image

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeIndex = prefs.getInt(_themeModeKey) ?? ThemeMode.system.index;
    final accentColorValue = prefs.getInt(_accentColorKey) ?? AppColors.chakraBlue.value;
    final useAnimatedBg = prefs.getBool(_animatedBgKey) ?? true;
    final soundPackIndex = prefs.getInt(_soundPackKey) ?? SoundPack.naruto.index;
    final onboardingCompleted = prefs.getBool(_onboardingKey) ?? false;
    final characterPathName = prefs.getString(_characterPathKey);
    // Load profile image selection
    final profileImageIndex = prefs.getInt(_profileImageKey) ?? CharacterEvolution.kid.index;
    // Load reminders
    final remindersJsonString = prefs.getString(_remindersKey);
    List<ReminderSetting> reminders = [];
    if (remindersJsonString != null) {
      try {
         final List<dynamic> decodedList = jsonDecode(remindersJsonString);
         reminders = decodedList
            .map((item) => ReminderSetting.fromJson(item as Map<String, dynamic>))
            .toList();
      } catch (e) {
         print("Error decoding reminders: $e"); // Handle potential decoding errors
      }
    }

    state = UserPreferences(
      themeMode: ThemeMode.values[themeModeIndex],
      accentColor: Color(accentColorValue),
      useAnimatedBackground: useAnimatedBg,
      soundPack: SoundPack.values[soundPackIndex],
      hasCompletedOnboarding: onboardingCompleted,
      characterPath: characterPathName != null
          ? CharacterPath.values.firstWhere((e) => e.name == characterPathName)
          : null,
      reminders: reminders, // Assign loaded reminders
      selectedProfileImage: CharacterEvolution.values[profileImageIndex],
    );
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, state.themeMode.index);
    await prefs.setInt(_accentColorKey, state.accentColor.value);
    await prefs.setBool(_animatedBgKey, state.useAnimatedBackground);
    await prefs.setInt(_soundPackKey, state.soundPack.index);
    await prefs.setBool(_onboardingKey, state.hasCompletedOnboarding);
    if (state.characterPath != null) {
       await prefs.setString(_characterPathKey, state.characterPath!.name);
    } else {
       await prefs.remove(_characterPathKey);
    }
    // Save profile image selection
    await prefs.setInt(_profileImageKey, state.selectedProfileImage.index);
    // Save reminders
    final remindersJsonString = jsonEncode(state.reminders.map((r) => r.toJson()).toList());
    await prefs.setString(_remindersKey, remindersJsonString);
  }

  void updateThemeMode(ThemeMode mode) {
    if (state.themeMode != mode) {
      state = state.copyWith(themeMode: mode);
      _savePreferences();
    }
  }

  void updateAccentColor(Color color) {
     if (state.accentColor != color) {
      state = state.copyWith(accentColor: color);
      _savePreferences();
    }
  }

  void toggleAnimatedBackground(bool value) {
     if (state.useAnimatedBackground != value) {
      state = state.copyWith(useAnimatedBackground: value);
      _savePreferences();
    }
  }

  void updateSoundPack(SoundPack pack) {
     if (state.soundPack != pack) {
      state = state.copyWith(soundPack: pack);
      _savePreferences();
    }
  }

  // Update selected profile image
  void updateProfileImage(CharacterEvolution evolution) {
    if (state.selectedProfileImage != evolution) {
      state = state.copyWith(selectedProfileImage: evolution);
      _savePreferences();
    }
  }

  void completeOnboarding(CharacterPath path) {
     state = state.copyWith(
        hasCompletedOnboarding: true,
        characterPath: path,
     );
     _savePreferences();
  }

   void resetOnboarding() {
     state = state.copyWith(
        hasCompletedOnboarding: false,
        clearCharacterPath: true, // Use the flag to set characterPath to null
     );
     _savePreferences();
  }

  // --- Methods for Character Path (if needed) ---
  // void setCharacterPath(CharacterPath path) {
  //   state = state.copyWith(characterPath: path);
  //   _savePreferences();
  // }

  // --- Methods for Reminders (Implement actual logic) ---
  void addReminder(TimeOfDay time, String message) {
    final newReminder = ReminderSetting(time: time, message: message);
    state = state.copyWith(reminders: [...state.reminders, newReminder]);
    _savePreferences(); // Save updated list
    print("Reminder Added: ${newReminder.id}");
  }

  void toggleReminder(String id, bool isEnabled) {
    state = state.copyWith(
      reminders: state.reminders.map((r) {
        if (r.id == id) {
          return r.copyWith(isEnabled: isEnabled);
        }
        return r;
      }).toList(),
    );
    _savePreferences(); // Save updated list
    print("Reminder Toggled: $id - $isEnabled");
  }

  void removeReminder(String id) {
     state = state.copyWith(
       reminders: state.reminders.where((r) => r.id != id).toList()
     );
     _savePreferences(); // Save updated list
     print("Reminder Removed: $id");
  }
}
