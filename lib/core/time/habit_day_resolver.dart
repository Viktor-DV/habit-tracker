import 'package:flutter/material.dart' show DateUtils;

/// Maps a wall-clock [DateTime] to the logical "habit day".
///
/// If the clock reads before [dayStartHour]:[dayStartMinute], the moment
/// still belongs to the *previous* calendar day.
///
/// Example: dayStart = 06:00
///   01:30 Wed  →  logical day = Tue
///   06:00 Wed  →  logical day = Wed
///   23:59 Wed  →  logical day = Wed
DateTime resolveHabitDay(
  DateTime wallClock, {
  int dayStartHour = 6,
  int dayStartMinute = 0,
}) {
  final calendarDay = DateUtils.dateOnly(wallClock);
  final dayStart = calendarDay.add(
    Duration(hours: dayStartHour, minutes: dayStartMinute),
  );
  return wallClock.isBefore(dayStart)
      ? calendarDay.subtract(const Duration(days: 1))
      : calendarDay;
}

/// Convenience: returns the current logical habit day using [DateTime.now()].
DateTime todayHabitDay({int dayStartHour = 6, int dayStartMinute = 0}) =>
    resolveHabitDay(
      DateTime.now(),
      dayStartHour: dayStartHour,
      dayStartMinute: dayStartMinute,
    );
