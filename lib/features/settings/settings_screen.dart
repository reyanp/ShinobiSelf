import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shinobi_self/core/theme/app_colors.dart';
import 'package:shinobi_self/core/theme/app_text_styles.dart';
import 'package:shinobi_self/models/user_preferences.dart';
import 'package:shinobi_self/models/character_path.dart';
import 'package:uuid/uuid.dart'; // For generating reminder IDs

// Import providers needed for reset
import 'package:shinobi_self/models/user_progress.dart';
import 'package:shinobi_self/features/home/home_dashboard.dart'; // For mission providers
import 'package:shinobi_self/features/achievements/achievements_screen.dart';
import 'package:shinobi_self/models/mood_entry.dart'; // For mood provider

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(userPrefsProvider);
    final prefsNotifier = ref.read(userPrefsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionHeader(context, 'Appearance'),
          _buildThemeModeSetting(context, prefs.themeMode, prefsNotifier),
          const Divider(),
          _buildAccentColorSetting(context, prefs.accentColor, prefsNotifier),
          const Divider(),
          _buildAnimatedBackgroundSetting(context, prefs.useAnimatedBackground, prefsNotifier),
          const SizedBox(height: 24),

          _buildSectionHeader(context, 'Sound'),
          _buildSoundPackSetting(context, prefs.soundPack, prefsNotifier),
          const SizedBox(height: 24),

          _buildSectionHeader(context, 'Mindfulness Reminders'),
          _buildReminderSettings(context, prefs.reminders, prefsNotifier),
          const SizedBox(height: 24),
          
          _buildSectionHeader(context, 'Account'),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Reset Progress & Onboarding'),
            subtitle: const Text('Warning: This cannot be undone.'),
            onTap: () => _showResetProgressDialog(context, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
      ),
    );
  }

  // --- Appearance Settings ---

  Widget _buildThemeModeSetting(BuildContext context, ThemeMode currentMode, UserPreferencesNotifier notifier) {
    return ListTile(
      leading: const Icon(Icons.brightness_6),
      title: const Text('App Theme'),
      trailing: SegmentedButton<ThemeMode>(
        segments: const [
          ButtonSegment(value: ThemeMode.light, label: Text('Light'), icon: Icon(Icons.wb_sunny)),
          ButtonSegment(value: ThemeMode.system, label: Text('System'), icon: Icon(Icons.brightness_auto)),
          ButtonSegment(value: ThemeMode.dark, label: Text('Dark'), icon: Icon(Icons.nightlight_round)),
        ],
        selected: {currentMode},
        onSelectionChanged: (Set<ThemeMode> newSelection) {
          notifier.updateThemeMode(newSelection.first);
        },
        showSelectedIcon: false,
        style: SegmentedButton.styleFrom(
          visualDensity: VisualDensity.compact,
        )
      ),
    );
  }

  Widget _buildAccentColorSetting(BuildContext context, Color currentColor, UserPreferencesNotifier notifier) {
    final availableColors = {
      'Blue Chakra': AppColors.chakraBlue,
      'Red Chakra': AppColors.chakraRed,
      'Green Chakra': AppColors.chakraGreen, // Assuming you have this defined
    };

    return ListTile(
      leading: const Icon(Icons.color_lens),
      title: const Text('Accent Color'),
      subtitle: Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        children: availableColors.entries.map((entry) {
          final colorName = entry.key;
          final colorValue = entry.value;
          final isSelected = currentColor.value == colorValue.value;
          return ChoiceChip(
            label: Text(colorName),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                notifier.updateAccentColor(colorValue);
              }
            },
            avatar: CircleAvatar(
              backgroundColor: colorValue,
              radius: 10,
            ),
            selectedColor: colorValue.withOpacity(0.2),
            shape: StadiumBorder(
              side: BorderSide(
                color: isSelected ? colorValue : Colors.transparent,
                width: 1.5,
              ),
            ),
            visualDensity: VisualDensity.compact,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAnimatedBackgroundSetting(BuildContext context, bool isEnabled, UserPreferencesNotifier notifier) {
    return SwitchListTile(
      secondary: const Icon(Icons.animation),
      title: const Text('Animated Background'),
      subtitle: const Text('Enable subtle background effects'),
      value: isEnabled,
      onChanged: (value) => notifier.toggleAnimatedBackground(value),
    );
  }

  // --- Sound Settings ---
  Widget _buildSoundPackSetting(BuildContext context, SoundPack currentPack, UserPreferencesNotifier notifier) {
    return ListTile(
       leading: const Icon(Icons.music_note),
       title: const Text('Quest & Reminder Sounds'),
       trailing: DropdownButton<SoundPack>(
         value: currentPack,
         onChanged: (SoundPack? newValue) {
           if (newValue != null) {
             notifier.updateSoundPack(newValue);
           }
         },
         items: SoundPack.values.map<DropdownMenuItem<SoundPack>>((SoundPack value) {
           String text;
           switch (value) {
             case SoundPack.naruto: text = 'Naruto Clips'; break;
             case SoundPack.traditional: text = 'Japanese Instruments'; break;
             case SoundPack.nature: text = 'Nature Tones'; break;
           }
           return DropdownMenuItem<SoundPack>(
             value: value,
             child: Text(text),
           );
         }).toList(),
       ),
    );
  }

 // --- Reminder Settings ---

 Widget _buildReminderSettings(BuildContext context, List<ReminderSetting> reminders, UserPreferencesNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display existing reminders (placeholder UI)
        if (reminders.isEmpty)
          ListTile(
            leading: const Icon(Icons.notifications_off),
            title: const Text('No reminders set'),
            subtitle: const Text('Tap button below to add one'),
          )
        else
          ...reminders.map((r) => ListTile(
                leading: Icon(r.isEnabled ? Icons.notifications_active : Icons.notifications_paused),
                title: Text(r.message),
                subtitle: Text(r.time.format(context)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                     Switch(
                       value: r.isEnabled,
                       onChanged: (value) => notifier.toggleReminder(r.id, value),
                       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                     ),
                     IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      onPressed: () => notifier.removeReminder(r.id),
                      tooltip: 'Delete Reminder',
                    ),
                  ],
                ),
              )),
        const SizedBox(height: 16),
        Center(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add_alert),
            label: const Text('Add Mindfulness Reminder'),
            onPressed: () => _showAddReminderDialog(context, notifier),
          ),
        ),
         Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            'Note: Actual push notifications require additional setup.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Future<void> _showAddReminderDialog(BuildContext context, UserPreferencesNotifier notifier) async {
    TimeOfDay? selectedTime = TimeOfDay.now();
    String message = 'Mindfulness Check-in';
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) {
        // Use StatefulBuilder to manage state within the dialog (for time picker)
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Reminder'),
              content: Form(
                 key: formKey,
                 child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                       initialValue: message,
                       decoration: const InputDecoration(labelText: 'Reminder Message'),
                       validator: (value) => value == null || value.isEmpty ? 'Please enter a message' : null,
                       onSaved: (value) => message = value!,
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                       contentPadding: EdgeInsets.zero,
                       title: const Text('Reminder Time'),
                       trailing: TextButton(
                         // Use null check for format
                         child: Text(selectedTime?.format(context) ?? 'Select Time'), 
                         onPressed: () async {
                            final TimeOfDay? picked = await showTimePicker(
                              context: context,
                              // Provide non-null initialTime
                              initialTime: selectedTime ?? TimeOfDay.now(), 
                            );
                            if (picked != null && picked != selectedTime) {
                               // Update state using StatefulBuilder's setState
                               setState(() {
                                 selectedTime = picked;
                               });
                            }
                         },
                       ),
                    ),
                  ],
                ), 
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                TextButton(
                  onPressed: () {
                    // Ensure time is selected before saving
                    if (selectedTime == null) {
                       ScaffoldMessenger.of(context).showSnackBar(
                         const SnackBar(content: Text('Please select a time')),
                       );
                       return;
                    }
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      // Pass non-null time
                      notifier.addReminder(selectedTime!, message); 
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          }
        );
      },
    );
  }

  // --- Reset Progress Dialog ---
  void _showResetProgressDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reset Progress?'),
          content: const Text(
            'This will delete all your progress (XP, rank, missions, achievements) and reset onboarding. This action cannot be undone.',
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                 // Reset UserPreferences (including character path and onboarding)
                 ref.read(userPrefsProvider.notifier).resetOnboarding();

                 // Reset UserProgress to its initial state explicitly
                 ref.read(userProgressProvider.notifier).state = UserProgress(
                    xp: 0,
                    level: 1,
                    rank: NinjaRank.genin,
                    streak: 0,
                    completedMissions: 0,
                    totalMissionsCompleted: 0,
                 );
                 
                 // Invalidate other dependent providers to force re-fetch/rebuild
                 ref.invalidate(dailyMissionsProvider);
                 ref.invalidate(weeklyMissionsProvider);
                 ref.invalidate(achievementsProvider);
                 ref.invalidate(moodEntriesProvider);
                 ref.invalidate(userXpProvider); // Also invalidate simple XP provider
                 ref.invalidate(userStreakProvider); // Also invalidate simple streak provider

                 Navigator.pop(context); // Close dialog

                 // Navigate back to onboarding screen after resetting
                 Navigator.pushNamedAndRemoveUntil(context, '/onboarding', (route) => false);

                 // Show snackbar confirmation (optional, could be shown on onboarding screen)
                 ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(content: Text('Progress Reset Successfully'), backgroundColor: Colors.orange),
                 );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }
}
