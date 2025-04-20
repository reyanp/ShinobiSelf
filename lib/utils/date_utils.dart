// Basic date utilities for the app

/// Checks if two dates are on the same day
bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year && 
         date1.month == date2.month && 
         date1.day == date2.day;
}

/// Returns date with time set to midnight
DateTime stripTime(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

/// Checks if date is today
bool isToday(DateTime date) {
  final now = DateTime.now();
  return isSameDay(date, now);
} 