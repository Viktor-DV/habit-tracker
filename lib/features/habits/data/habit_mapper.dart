import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/core/database/app_database.dart';
import 'package:habit_tracker/features/habits/domain/habit.dart';
import 'package:habit_tracker/features/habits/domain/habit_entry.dart';
import 'package:habit_tracker/features/habits/domain/habit_enums.dart';

// ---------------------------------------------------------------------------
// HabitRow ↔ Habit
// ---------------------------------------------------------------------------

Habit habitFromRow(HabitRow row) {
  List<int> weekdays = [];
  if (row.repeatDaysJson != null) {
    weekdays = (jsonDecode(row.repeatDaysJson!) as List).cast<int>();
  }

  List<String> times = [];
  if (row.notificationTimesJson != null) {
    times =
        (jsonDecode(row.notificationTimesJson!) as List).cast<String>();
  }

  return Habit(
    id: row.id,
    title: row.title,
    description: row.description,
    habitKind: HabitKindExt.fromDb(row.habitKind),
    completionType: CompletionTypeExt.fromDb(row.completionType),
    visualType: VisualTypeExt.fromDb(row.visualType),
    iconName: row.iconName,
    emoji: row.emoji,
    photoPath: row.photoPath,
    color: Color(row.colorValue),
    targetValue: row.targetValue,
    targetUnit: row.targetUnit,
    repeatType: RepeatTypeExt.fromDb(row.repeatType),
    repeatWeekdays: weekdays,
    repeatInterval: row.repeatInterval,
    repeatGoalCount: row.repeatGoalCount,
    repeatPeriodDays: row.repeatPeriodDays,
    repeatStartDate: DateTime.parse(row.repeatStartDate),
    isActive: row.isActive,
    createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAt),
    notificationMode: NotificationModeExt.fromDb(row.notificationMode),
    notificationTimes: times,
    timerEnabled: row.timerEnabled,
    sortOrder: row.sortOrder,
  );
}

HabitsCompanion habitToCompanion(Habit h) {
  final weekdaysJson =
      h.repeatWeekdays.isEmpty ? null : jsonEncode(h.repeatWeekdays);
  final timesJson =
      h.notificationTimes.isEmpty ? null : jsonEncode(h.notificationTimes);

  return HabitsCompanion(
    id: h.id == 0 ? const Value.absent() : Value(h.id),
    title: Value(h.title),
    description: Value(h.description),
    habitKind: Value(h.habitKind.toDb()),
    completionType: Value(h.completionType.toDb()),
    visualType: Value(h.visualType.toDb()),
    iconName: Value(h.iconName),
    emoji: Value(h.emoji),
    photoPath: Value(h.photoPath),
    colorValue: Value(h.color.toARGB32()),
    targetValue: Value(h.targetValue),
    targetUnit: Value(h.targetUnit),
    repeatType: Value(h.repeatType.toDb()),
    repeatDaysJson: Value(weekdaysJson),
    repeatInterval: Value(h.repeatInterval),
    repeatGoalCount: Value(h.repeatGoalCount),
    repeatPeriodDays: Value(h.repeatPeriodDays),
    repeatStartDate: Value(_formatDate(h.repeatStartDate)),
    isActive: Value(h.isActive),
    createdAt: Value(h.createdAt.millisecondsSinceEpoch),
    notificationMode: Value(h.notificationMode.toDb()),
    notificationTimesJson: Value(timesJson),
    timerEnabled: Value(h.timerEnabled),
    sortOrder: Value(h.sortOrder),
  );
}

// ---------------------------------------------------------------------------
// HabitEntryRow ↔ HabitEntry
// ---------------------------------------------------------------------------

HabitEntry entryFromRow(HabitEntryRow row) {
  return HabitEntry(
    id: row.id,
    habitId: row.habitId,
    date: DateTime.parse(row.date),
    status: EntryStatusExt.fromDb(row.status),
    value: row.value,
    createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAt),
    updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAt),
  );
}

HabitEntriesCompanion entryToCompanion(HabitEntry e) {
  final now = DateTime.now().millisecondsSinceEpoch;
  return HabitEntriesCompanion(
    id: e.id == 0 ? const Value.absent() : Value(e.id),
    habitId: Value(e.habitId),
    date: Value(_formatDate(e.date)),
    status: Value(e.status.toDb()),
    value: Value(e.value),
    createdAt: Value(
      e.id == 0 ? now : e.createdAt.millisecondsSinceEpoch,
    ),
    updatedAt: Value(now),
  );
}

String _formatDate(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';
