import 'package:flutter/material.dart' show DateUtils;
import 'package:habit_tracker/features/habits/domain/habit.dart';
import 'package:habit_tracker/features/habits/domain/habit_enums.dart';

/// Returns `true` if [habit] is expected to be performed on the logical [date].
///
/// [date] must be a date-only value (time component = 00:00:00).
/// Use [resolveHabitDay] to obtain the logical date from a wall-clock time.
bool isExpectedOn(Habit habit, DateTime date) {
  if (!habit.isActive) return false;

  final start = DateUtils.dateOnly(habit.repeatStartDate);
  if (date.isBefore(start)) return false;

  return switch (habit.repeatType) {
    RepeatType.everyDay => true,
    RepeatType.selectedWeekdays => _matchesWeekday(habit.repeatWeekdays, date),
    RepeatType.everyNDays => _matchesEveryNDays(
        start,
        date,
        habit.repeatInterval ?? 1,
      ),
    // ponytail: nTimesPerNDays – any day in the period is a candidate;
    // the exact quota (goalCount / periodDays) is enforced by
    // ExpectedDaysCalculator for statistics, not per-day gating.
    RepeatType.nTimesPerNDays => true,
  };
}

bool _matchesWeekday(List<int> weekdays, DateTime date) {
  if (weekdays.isEmpty) return false;
  // DateTime.weekday: 1=Mon … 7=Sun — same convention as stored in DB.
  return weekdays.contains(date.weekday);
}

bool _matchesEveryNDays(DateTime start, DateTime date, int n) {
  if (n <= 0) return false;
  final diff = date.difference(start).inDays;
  return diff % n == 0;
}
