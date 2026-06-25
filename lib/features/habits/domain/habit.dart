import 'package:flutter/material.dart';
import 'habit_enums.dart';

class Habit {
  const Habit({
    required this.id,
    required this.title,
    this.description,
    required this.habitKind,
    required this.completionType,
    required this.visualType,
    this.iconName,
    this.emoji,
    this.photoPath,
    required this.color,
    this.targetValue,
    this.targetUnit,
    required this.repeatType,
    this.repeatWeekdays = const [],
    this.repeatInterval,
    this.repeatGoalCount,
    this.repeatPeriodDays,
    required this.repeatStartDate,
    required this.isActive,
    required this.createdAt,
    required this.notificationMode,
    this.notificationTimes = const [],
    this.timerEnabled = false,
    this.sortOrder = 0,
  });

  final int id;
  final String title;
  final String? description;
  final HabitKind habitKind;
  final CompletionType completionType;
  final VisualType visualType;
  final String? iconName;
  final String? emoji;
  final String? photoPath;
  final Color color;
  final double? targetValue;
  final String? targetUnit;
  final RepeatType repeatType;

  /// Weekday numbers 1=Mon … 7=Sun (for selectedWeekdays)
  final List<int> repeatWeekdays;

  /// For everyNDays
  final int? repeatInterval;

  /// For nTimesPerNDays
  final int? repeatGoalCount;
  final int? repeatPeriodDays;

  final DateTime repeatStartDate;
  final bool isActive;
  final DateTime createdAt;
  final NotificationMode notificationMode;

  /// Time strings "HH:mm"
  final List<String> notificationTimes;

  final bool timerEnabled;
  final int sortOrder;

  Habit copyWith({
    int? id,
    String? title,
    String? description,
    HabitKind? habitKind,
    CompletionType? completionType,
    VisualType? visualType,
    String? iconName,
    String? emoji,
    String? photoPath,
    Color? color,
    double? targetValue,
    String? targetUnit,
    RepeatType? repeatType,
    List<int>? repeatWeekdays,
    int? repeatInterval,
    int? repeatGoalCount,
    int? repeatPeriodDays,
    DateTime? repeatStartDate,
    bool? isActive,
    DateTime? createdAt,
    NotificationMode? notificationMode,
    List<String>? notificationTimes,
    bool? timerEnabled,
    int? sortOrder,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      habitKind: habitKind ?? this.habitKind,
      completionType: completionType ?? this.completionType,
      visualType: visualType ?? this.visualType,
      iconName: iconName ?? this.iconName,
      emoji: emoji ?? this.emoji,
      photoPath: photoPath ?? this.photoPath,
      color: color ?? this.color,
      targetValue: targetValue ?? this.targetValue,
      targetUnit: targetUnit ?? this.targetUnit,
      repeatType: repeatType ?? this.repeatType,
      repeatWeekdays: repeatWeekdays ?? this.repeatWeekdays,
      repeatInterval: repeatInterval ?? this.repeatInterval,
      repeatGoalCount: repeatGoalCount ?? this.repeatGoalCount,
      repeatPeriodDays: repeatPeriodDays ?? this.repeatPeriodDays,
      repeatStartDate: repeatStartDate ?? this.repeatStartDate,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      notificationMode: notificationMode ?? this.notificationMode,
      notificationTimes: notificationTimes ?? this.notificationTimes,
      timerEnabled: timerEnabled ?? this.timerEnabled,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Habit && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
