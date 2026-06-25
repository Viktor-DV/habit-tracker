import 'package:flutter/material.dart' show DateUtils;
import 'package:habit_tracker/features/habits/domain/habit.dart';
import 'package:habit_tracker/features/habits/domain/habit_enums.dart';
import 'repeat_rule_evaluator.dart';

/// Returns every date in [[from], [to]] (inclusive) on which [habit] is expected.
///
/// For [RepeatType.nTimesPerNDays] this returns a representative set of dates:
/// the first [goalCount] days of each period window starting at [repeatStartDate].
/// This is used for streak & completion-rate calculations.
List<DateTime> expectedDaysInRange(
  Habit habit,
  DateTime from,
  DateTime to,
) {
  final start = DateUtils.dateOnly(from);
  final end = DateUtils.dateOnly(to);
  if (start.isAfter(end)) return const [];

  if (habit.repeatType == RepeatType.nTimesPerNDays) {
    return _nTimesExpected(habit, start, end);
  }

  final days = <DateTime>[];
  var cursor = start;
  while (!cursor.isAfter(end)) {
    if (isExpectedOn(habit, cursor)) days.add(cursor);
    cursor = cursor.add(const Duration(days: 1));
  }
  return days;
}

/// Total count of expected completions in [[from], [to]] (inclusive).
///
/// Cheaper than calling [expectedDaysInRange].length when only a count is needed.
int expectedCountInRange(Habit habit, DateTime from, DateTime to) {
  if (habit.repeatType == RepeatType.nTimesPerNDays) {
    return _nTimesExpected(habit, DateUtils.dateOnly(from),
            DateUtils.dateOnly(to))
        .length;
  }
  return expectedDaysInRange(habit, from, to).length;
}

// ---------------------------------------------------------------------------
// nTimesPerNDays helper
// ---------------------------------------------------------------------------

List<DateTime> _nTimesExpected(Habit habit, DateTime from, DateTime to) {
  final goalCount = habit.repeatGoalCount ?? 1;
  final periodDays = habit.repeatPeriodDays ?? 7;
  final habitStart = DateUtils.dateOnly(habit.repeatStartDate);

  final days = <DateTime>[];
  var windowStart = habitStart;

  // Advance windowStart to the first window that overlaps [from, to].
  if (from.isAfter(habitStart)) {
    final offsetDays = from.difference(habitStart).inDays;
    final completedWindows = offsetDays ~/ periodDays;
    windowStart = habitStart.add(Duration(days: completedWindows * periodDays));
  }

  while (!windowStart.isAfter(to)) {
    // Within this window, first [goalCount] days are "expected".
    for (var i = 0; i < goalCount; i++) {
      final day = windowStart.add(Duration(days: i));
      if (!day.isBefore(from) && !day.isAfter(to) && !day.isBefore(habitStart)) {
        days.add(day);
      }
    }
    windowStart = windowStart.add(Duration(days: periodDays));
  }

  return days;
}
