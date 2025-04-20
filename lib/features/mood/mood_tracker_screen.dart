import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shinobi_self/core/theme/app_colors.dart';
import 'package:shinobi_self/core/theme/app_text_styles.dart';
import 'package:shinobi_self/models/mood_entry.dart';
import 'package:intl/intl.dart';

class MoodTrackerScreen extends ConsumerWidget {
  const MoodTrackerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moodEntries = ref.watch(moodEntriesProvider);
    final hasTodaysMood = ref.watch(hasTodaysMoodProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!hasTodaysMood) _buildMoodCheckIn(context, ref),
          if (hasTodaysMood) _buildTodaysMoodSummary(context, ref),
          const SizedBox(height: 24),
          _buildMoodHistory(context, moodEntries),
          const SizedBox(height: 24),
          _buildMoodInsights(context, moodEntries),
        ],
      ),
    );
  }

  Widget _buildMoodCheckIn(BuildContext context, WidgetRef ref) {
    final selectedMood = ref.watch(selectedMoodProvider);
    final moodNote = ref.watch(moodNoteProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How are you feeling today?',
              style: isDarkMode
                  ? AppTextStyles.toDarkMode(AppTextStyles.heading2)
                  : AppTextStyles.heading2,
            ),
            const SizedBox(height: 8),
            Text(
              'Your daily mood check-in helps track your emotional journey',
              style: isDarkMode
                  ? AppTextStyles.toDarkMode(AppTextStyles.bodyMedium)
                  : AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: MoodType.values.map((mood) {
                final isSelected = selectedMood == mood;
                return GestureDetector(
                  onTap: () {
                    ref.read(selectedMoodProvider.notifier).state = mood;
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? mood.color
                              : mood.color.withOpacity(0.3),
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(
                                  color: AppColors.chakraBlue, width: 3)
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            mood.emoji,
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        mood.label,
                        style: isDarkMode
                            ? AppTextStyles.toDarkMode(AppTextStyles.bodySmall)
                                .copyWith(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              )
                            : AppTextStyles.bodySmall.copyWith(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? AppColors.textPrimary
                                    : AppColors.textSecondary,
                              ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            TextField(
              onChanged: (value) {
                ref.read(moodNoteProvider.notifier).state = value;
              },
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Add a note about how you\'re feeling (optional)',
                hintStyle: isDarkMode
                    ? AppTextStyles.toDarkMode(AppTextStyles.bodySmall)
                    : AppTextStyles.bodySmall,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              style: isDarkMode
                  ? AppTextStyles.toDarkMode(AppTextStyles.bodyMedium)
                  : AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedMood == null
                    ? null
                    : () => _submitMoodEntry(context, ref),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Submit Mood',
                  style: AppTextStyles.buttonLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitMoodEntry(BuildContext context, WidgetRef ref) {
    final selectedMood = ref.read(selectedMoodProvider);
    final moodNote = ref.read(moodNoteProvider);

    if (selectedMood != null) {
      final newEntry = MoodEntry(
        date: DateTime.now(),
        mood: selectedMood,
        note: moodNote.isNotEmpty ? moodNote : null,
      );

      final currentEntries = ref.read(moodEntriesProvider);
      ref.read(moodEntriesProvider.notifier).state = [
        newEntry,
        ...currentEntries,
      ];

      // Reset providers
      ref.read(selectedMoodProvider.notifier).state = null;
      ref.read(moodNoteProvider.notifier).state = "";

      // Show feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mood logged successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  Widget _buildTodaysMoodSummary(BuildContext context, WidgetRef ref) {
    final moodEntries = ref.watch(moodEntriesProvider);
    final today = DateTime.now();
    final todayEntry = moodEntries.firstWhere((entry) =>
        entry.date.year == today.year &&
        entry.date.month == today.month &&
        entry.date.day == today.day);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: todayEntry.mood.color,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      todayEntry.mood.emoji,
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Today\'s Mood',
                        style: isDarkMode
                            ? AppTextStyles.toDarkMode(AppTextStyles.bodySmall)
                            : AppTextStyles.bodySmall,
                      ),
                      Text(
                        todayEntry.mood.label,
                        style: isDarkMode
                            ? AppTextStyles.toDarkMode(AppTextStyles.heading3)
                            : AppTextStyles.heading3,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon:
                      Icon(Icons.edit, color: isDarkMode ? Colors.white : null),
                  onPressed: () {
                    // Allow editing today's mood
                    final currentEntries = ref.read(moodEntriesProvider);
                    ref.read(moodEntriesProvider.notifier).state =
                        currentEntries
                            .where((entry) =>
                                entry.date.year != today.year ||
                                entry.date.month != today.month ||
                                entry.date.day != today.day)
                            .toList();

                    // Pre-fill the form
                    ref.read(selectedMoodProvider.notifier).state =
                        todayEntry.mood;
                    ref.read(moodNoteProvider.notifier).state =
                        todayEntry.note ?? "";
                  },
                ),
              ],
            ),
            if (todayEntry.note != null) ...[
              const SizedBox(height: 16),
              Text(
                'Your note:',
                style: isDarkMode
                    ? AppTextStyles.toDarkMode(AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ))
                    : AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
              ),
              const SizedBox(height: 4),
              Text(
                todayEntry.note!,
                style: isDarkMode
                    ? AppTextStyles.toDarkMode(AppTextStyles.bodyMedium)
                    : AppTextStyles.bodyMedium,
              ),
            ],
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: todayEntry.mood.color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hokage Wisdom:',
                    style: isDarkMode
                        ? AppTextStyles.toDarkMode(
                            AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ))
                        : AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    todayEntry.mood.narutoPhraseForMood,
                    style: isDarkMode
                        ? AppTextStyles.toDarkMode(AppTextStyles.bodyMedium)
                        : AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodHistory(BuildContext context, List<MoodEntry> entries) {
    final dateFormat = DateFormat('MMM d');
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mood History',
          style: isDarkMode
              ? AppTextStyles.toDarkMode(AppTextStyles.heading2)
              : AppTextStyles.heading2,
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return Container(
                width: 80,
                margin: const EdgeInsets.only(right: 12),
                child: Column(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: entry.mood.color,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          entry.mood.emoji,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      dateFormat.format(entry.date),
                      style: isDarkMode
                          ? AppTextStyles.toDarkMode(AppTextStyles.bodySmall)
                          : AppTextStyles.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      entry.mood.label,
                      style: isDarkMode
                          ? AppTextStyles.toDarkMode(
                              AppTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.bold,
                            ))
                          : AppTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMoodInsights(BuildContext context, List<MoodEntry> entries) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Calculate mood distribution
    final moodCounts = <MoodType, int>{};
    for (final type in MoodType.values) {
      moodCounts[type] = 0;
    }

    for (final entry in entries) {
      moodCounts[entry.mood] = (moodCounts[entry.mood] ?? 0) + 1;
    }

    // Find most common mood
    MoodType? mostCommonMood;
    int maxCount = 0;
    moodCounts.forEach((mood, count) {
      if (count > maxCount) {
        maxCount = count;
        mostCommonMood = mood;
      }
    });

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mood Insights',
              style: isDarkMode
                  ? AppTextStyles.toDarkMode(AppTextStyles.heading3)
                  : AppTextStyles.heading3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                if (mostCommonMood != null) ...[
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: mostCommonMood!.color,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        mostCommonMood!.emoji,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Your most common mood is ${mostCommonMood!.label}',
                      style: isDarkMode
                          ? AppTextStyles.toDarkMode(AppTextStyles.bodyMedium)
                          : AppTextStyles.bodyMedium,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Mood Distribution',
              style: isDarkMode
                  ? AppTextStyles.toDarkMode(AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ))
                  : AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
            ),
            const SizedBox(height: 8),
            Row(
              children: MoodType.values.map((mood) {
                final count = moodCounts[mood] ?? 0;
                final percentage =
                    entries.isEmpty ? 0.0 : count / entries.length;

                return Expanded(
                  flex: count == 0 ? 1 : (count * 10).round(),
                  child: Container(
                    height: 24,
                    color: mood.color,
                    child: Center(
                      child: Text(
                        '${(percentage * 100).round()}%',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Text(
              'Total entries: ${entries.length}',
              style: isDarkMode
                  ? AppTextStyles.toDarkMode(AppTextStyles.bodySmall)
                  : AppTextStyles.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
