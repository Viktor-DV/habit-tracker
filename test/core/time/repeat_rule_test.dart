import 'package:flutter/material.dart' show Colors;
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/core/time/expected_days_calculator.dart';
import 'package:habit_tracker/core/time/habit_day_resolver.dart';
import 'package:habit_tracker/core/time/repeat_rule_evaluator.dart';
import 'package:habit_tracker/features/habits/domain/habit.dart';
import 'package:habit_tracker/features/habits/domain/habit_enums.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Habit _habit({
  RepeatType type = RepeatType.everyDay,
  DateTime? startDate,
  List<int> weekdays = const [],
  int interval = 1,
  int goalCount = 3,
  int periodDays = 7,
  bool isActive = true,
}) {
  final start = startDate ?? DateTime(2024, 1, 1); // Monday
  return Habit(
    id: 0,
    title: 'test',
    habitKind: HabitKind.positive,
    completionType: CompletionType.yesNo,
    visualType: VisualType.icon,
    color: Colors.blue,
    repeatType: type,
    repeatWeekdays: weekdays,
    repeatInterval: interval,
    repeatGoalCount: goalCount,
    repeatPeriodDays: periodDays,
    repeatStartDate: start,
    isActive: isActive,
    createdAt: start,
    notificationMode: NotificationMode.none,
  );
}

DateTime d(int year, int month, int day) => DateTime(year, month, day);

// ---------------------------------------------------------------------------
// HabitDayResolver
// ---------------------------------------------------------------------------

void main() {
  group('HabitDayResolver', () {
    test('before dayStart belongs to previous day', () {
      // 01:30 on Wednesday → Tuesday
      final wallClock = DateTime(2024, 6, 5, 1, 30); // Wednesday
      final result = resolveHabitDay(wallClock, dayStartHour: 6);
      expect(result, d(2024, 6, 4)); // Tuesday
    });

    test('at dayStart belongs to same day', () {
      final wallClock = DateTime(2024, 6, 5, 6, 0);
      expect(resolveHabitDay(wallClock, dayStartHour: 6), d(2024, 6, 5));
    });

    test('after dayStart belongs to same day', () {
      final wallClock = DateTime(2024, 6, 5, 23, 59);
      expect(resolveHabitDay(wallClock, dayStartHour: 6), d(2024, 6, 5));
    });

    test('midnight (00:00) before dayStart belongs to previous day', () {
      final wallClock = DateTime(2024, 6, 5, 0, 0);
      expect(resolveHabitDay(wallClock, dayStartHour: 6), d(2024, 6, 4));
    });

    test('dayStart=0 means midnight — 00:00 is same day', () {
      final wallClock = DateTime(2024, 6, 5, 0, 0);
      expect(resolveHabitDay(wallClock, dayStartHour: 0), d(2024, 6, 5));
    });
  });

  // ---------------------------------------------------------------------------
  // RepeatRuleEvaluator — everyDay
  // ---------------------------------------------------------------------------

  group('isExpectedOn — everyDay', () {
    final habit = _habit(type: RepeatType.everyDay, startDate: d(2024, 1, 1));

    test('on start date', () => expect(isExpectedOn(habit, d(2024, 1, 1)), isTrue));
    test('after start date', () => expect(isExpectedOn(habit, d(2024, 6, 15)), isTrue));
    test('before start date', () => expect(isExpectedOn(habit, d(2023, 12, 31)), isFalse));
    test('inactive habit', () {
      final inactive = _habit(isActive: false);
      expect(isExpectedOn(inactive, d(2024, 1, 1)), isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // RepeatRuleEvaluator — selectedWeekdays
  // ---------------------------------------------------------------------------

  group('isExpectedOn — selectedWeekdays', () {
    // Mon=1, Wed=3, Fri=5
    final habit = _habit(
      type: RepeatType.selectedWeekdays,
      startDate: d(2024, 1, 1), // Monday
      weekdays: [1, 3, 5],
    );

    test('Monday (listed) → expected', () {
      // 2024-01-01 is Monday (weekday=1)
      expect(isExpectedOn(habit, d(2024, 1, 1)), isTrue);
    });

    test('Tuesday (not listed) → not expected', () {
      expect(isExpectedOn(habit, d(2024, 1, 2)), isFalse);
    });

    test('Wednesday (listed) → expected', () {
      expect(isExpectedOn(habit, d(2024, 1, 3)), isTrue);
    });

    test('Sunday (not listed) → not expected', () {
      expect(isExpectedOn(habit, d(2024, 1, 7)), isFalse);
    });

    test('before start even on listed day → not expected', () {
      expect(isExpectedOn(habit, d(2023, 12, 29)), isFalse); // Friday before start
    });

    test('empty weekdays list → never expected', () {
      final noWeekdays = _habit(
        type: RepeatType.selectedWeekdays,
        weekdays: [],
      );
      expect(isExpectedOn(noWeekdays, d(2024, 1, 1)), isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // RepeatRuleEvaluator — everyNDays
  // ---------------------------------------------------------------------------

  group('isExpectedOn — everyNDays', () {
    final habit = _habit(
      type: RepeatType.everyNDays,
      startDate: d(2024, 1, 1),
      interval: 3,
    );

    test('start day (diff=0) → expected', () => expect(isExpectedOn(habit, d(2024, 1, 1)), isTrue));
    test('diff=3 → expected', () => expect(isExpectedOn(habit, d(2024, 1, 4)), isTrue));
    test('diff=6 → expected', () => expect(isExpectedOn(habit, d(2024, 1, 7)), isTrue));
    test('diff=1 → not expected', () => expect(isExpectedOn(habit, d(2024, 1, 2)), isFalse));
    test('diff=2 → not expected', () => expect(isExpectedOn(habit, d(2024, 1, 3)), isFalse));
    test('diff=9 → expected', () => expect(isExpectedOn(habit, d(2024, 1, 10)), isTrue));
  });

  // ---------------------------------------------------------------------------
  // RepeatRuleEvaluator — nTimesPerNDays (any day in range is "candidate")
  // ---------------------------------------------------------------------------

  group('isExpectedOn — nTimesPerNDays', () {
    final habit = _habit(
      type: RepeatType.nTimesPerNDays,
      startDate: d(2024, 1, 1),
      goalCount: 3,
      periodDays: 7,
    );

    test('any day from start is expected', () {
      expect(isExpectedOn(habit, d(2024, 1, 1)), isTrue);
      expect(isExpectedOn(habit, d(2024, 1, 5)), isTrue);
      expect(isExpectedOn(habit, d(2024, 3, 20)), isTrue);
    });

    test('before start → not expected', () {
      expect(isExpectedOn(habit, d(2023, 12, 31)), isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // ExpectedDaysCalculator — everyDay
  // ---------------------------------------------------------------------------

  group('expectedDaysInRange — everyDay', () {
    final habit = _habit(type: RepeatType.everyDay, startDate: d(2024, 1, 1));

    test('7-day range → 7 days', () {
      final days = expectedDaysInRange(habit, d(2024, 1, 1), d(2024, 1, 7));
      expect(days.length, 7);
    });

    test('range before start → 0 days', () {
      final days = expectedDaysInRange(habit, d(2023, 12, 1), d(2023, 12, 31));
      expect(days, isEmpty);
    });

    test('range overlapping start', () {
      final days = expectedDaysInRange(habit, d(2023, 12, 30), d(2024, 1, 3));
      // Only Jan 1–3 are >= startDate
      expect(days.length, 3);
      expect(days.first, d(2024, 1, 1));
    });
  });

  // ---------------------------------------------------------------------------
  // ExpectedDaysCalculator — selectedWeekdays
  // ---------------------------------------------------------------------------

  group('expectedDaysInRange — selectedWeekdays', () {
    // Mon+Fri in Jan 2024 (Jan 1 is Monday)
    final habit = _habit(
      type: RepeatType.selectedWeekdays,
      startDate: d(2024, 1, 1),
      weekdays: [1, 5], // Mon, Fri
    );

    test('whole January → 4 Mondays + 4 Fridays = 8', () {
      final days = expectedDaysInRange(habit, d(2024, 1, 1), d(2024, 1, 28));
      // Jan 1,5,8,12,15,19,22,26 = 8 days
      expect(days.length, 8);
    });

    test('single week Mon–Sun', () {
      final days = expectedDaysInRange(habit, d(2024, 1, 1), d(2024, 1, 7));
      expect(days.length, 2); // Mon 1 + Fri 5
      expect(days[0], d(2024, 1, 1));
      expect(days[1], d(2024, 1, 5));
    });
  });

  // ---------------------------------------------------------------------------
  // ExpectedDaysCalculator — everyNDays
  // ---------------------------------------------------------------------------

  group('expectedDaysInRange — everyNDays', () {
    final habit = _habit(
      type: RepeatType.everyNDays,
      startDate: d(2024, 1, 1),
      interval: 2,
    );

    test('10 days → 5 expected (days 1,3,5,7,9)', () {
      final days = expectedDaysInRange(habit, d(2024, 1, 1), d(2024, 1, 10));
      expect(days.length, 5);
    });
  });

  // ---------------------------------------------------------------------------
  // ExpectedDaysCalculator — nTimesPerNDays
  // ---------------------------------------------------------------------------

  group('expectedDaysInRange — nTimesPerNDays', () {
    // 3 times per 7 days starting 2024-01-01 (Monday)
    final habit = _habit(
      type: RepeatType.nTimesPerNDays,
      startDate: d(2024, 1, 1),
      goalCount: 3,
      periodDays: 7,
    );

    test('first window (Jan 1–7) → 3 expected (days 1,2,3)', () {
      final days = expectedDaysInRange(habit, d(2024, 1, 1), d(2024, 1, 7));
      expect(days.length, 3);
      expect(days[0], d(2024, 1, 1));
      expect(days[1], d(2024, 1, 2));
      expect(days[2], d(2024, 1, 3));
    });

    test('two full windows → 6 expected', () {
      final days = expectedDaysInRange(habit, d(2024, 1, 1), d(2024, 1, 14));
      expect(days.length, 6);
    });

    test('partial second window (just days 8–9) → 2 expected', () {
      final days = expectedDaysInRange(habit, d(2024, 1, 8), d(2024, 1, 9));
      expect(days.length, 2);
    });

    test('expectedCountInRange matches length', () {
      final count = expectedCountInRange(habit, d(2024, 1, 1), d(2024, 1, 21));
      expect(count, 9); // 3 windows × 3
    });
  });
}
