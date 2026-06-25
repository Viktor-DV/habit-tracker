import 'package:flutter/material.dart' show DateUtils;
import 'package:habit_tracker/core/time/expected_days_calculator.dart';
import 'package:habit_tracker/features/habits/domain/habit.dart';
import 'package:habit_tracker/features/habits/domain/habit_entry.dart';
import 'package:habit_tracker/features/habits/domain/habit_enums.dart';

/// Pure statistics functions. All take a pre-computed set of "done" date keys
/// (YYYY-MM-DD) so they are trivially unit-testable without a database.
///
/// ponytail: plain functions, not Calculator classes — the spec lists
/// "StreakCalculator" etc. as concepts, but a class with one method and no
/// state is just a function wearing a costume.

String dateKey(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

/// Builds the set of "successfully completed" date keys from raw entries.
/// done (positive) and success (negative) both count as completed.
Set<String> doneDateKeys(List<HabitEntry> entries) => {
      for (final e in entries)
        if (e.status == EntryStatus.done || e.status == EntryStatus.success)
          dateKey(e.date),
    };

/// Number of days the habit was expected ("ideal" days) in [from]..[to].
int idealDays(Habit habit, DateTime from, DateTime to) =>
    expectedCountInRange(habit, from, to);

/// Current streak: consecutive expected days completed, counting back from the
/// most recent expected day that is not in the future.
int currentStreak(Habit habit, Set<String> done, DateTime today) {
  final start = DateUtils.dateOnly(habit.repeatStartDate);
  final t = DateUtils.dateOnly(today);
  if (t.isBefore(start)) return 0;

  final expected = expectedDaysInRange(habit, start, t);
  var streak = 0;
  for (var i = expected.length - 1; i >= 0; i--) {
    if (done.contains(dateKey(expected[i]))) {
      streak++;
    } else {
      break;
    }
  }
  return streak;
}

/// Longest run of consecutive completed expected days up to [today].
int bestStreak(Habit habit, Set<String> done, DateTime today) {
  final start = DateUtils.dateOnly(habit.repeatStartDate);
  final t = DateUtils.dateOnly(today);
  if (t.isBefore(start)) return 0;

  final expected = expectedDaysInRange(habit, start, t);
  var best = 0;
  var run = 0;
  for (final d in expected) {
    if (done.contains(dateKey(d))) {
      run++;
      if (run > best) best = run;
    } else {
      run = 0;
    }
  }
  return best;
}

/// Completion rate in [from]..[to] as a fraction 0.0–1.0.
/// Returns 0.0 when no days were expected (avoids NaN).
double completionRate(
  Habit habit,
  Set<String> done,
  DateTime from,
  DateTime to,
) {
  final start = DateUtils.dateOnly(habit.repeatStartDate);
  final effectiveFrom = from.isBefore(start) ? start : from;
  final expected = expectedDaysInRange(habit, effectiveFrom, to);
  if (expected.isEmpty) return 0.0;
  final doneCount = expected.where((d) => done.contains(dateKey(d))).length;
  return doneCount / expected.length;
}

/// Total number of completed expected days in [from]..[to].
int completedCount(
  Habit habit,
  Set<String> done,
  DateTime from,
  DateTime to,
) {
  final start = DateUtils.dateOnly(habit.repeatStartDate);
  final effectiveFrom = from.isBefore(start) ? start : from;
  return expectedDaysInRange(habit, effectiveFrom, to)
      .where((d) => done.contains(dateKey(d)))
      .length;
}

/// Aggregated stats for one habit over a period.
class PeriodStats {
  const PeriodStats({
    required this.expected,
    required this.completed,
    required this.currentStreak,
    required this.bestStreak,
  });

  final int expected;
  final int completed;
  final int currentStreak;
  final int bestStreak;

  double get completionRate => expected == 0 ? 0.0 : completed / expected;
  int get missed => (expected - completed).clamp(0, expected);
}

/// Full period stats for a single habit.
PeriodStats periodStats(
  Habit habit,
  List<HabitEntry> entries,
  DateTime from,
  DateTime to,
  DateTime today,
) {
  final done = doneDateKeys(entries);
  final start = DateUtils.dateOnly(habit.repeatStartDate);
  final effectiveFrom = from.isBefore(start) ? start : from;
  final cappedTo = to.isAfter(today) ? today : to;

  final expected = idealDays(habit, effectiveFrom, cappedTo);
  final completed = completedCount(habit, done, effectiveFrom, cappedTo);

  return PeriodStats(
    expected: expected,
    completed: completed,
    currentStreak: currentStreak(habit, done, today),
    bestStreak: bestStreak(habit, done, today),
  );
}
