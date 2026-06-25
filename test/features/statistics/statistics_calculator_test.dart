import 'package:flutter/material.dart' show Colors;
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/features/habits/domain/habit.dart';
import 'package:habit_tracker/features/habits/domain/habit_entry.dart';
import 'package:habit_tracker/features/habits/domain/habit_enums.dart';
import 'package:habit_tracker/features/statistics/domain/statistics_calculator.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Habit _habit({
  RepeatType type = RepeatType.everyDay,
  DateTime? startDate,
  List<int> weekdays = const [],
  int interval = 1,
}) {
  final start = startDate ?? DateTime(2024, 1, 1); // Monday
  return Habit(
    id: 1,
    title: 'test',
    habitKind: HabitKind.positive,
    completionType: CompletionType.yesNo,
    visualType: VisualType.icon,
    color: Colors.blue,
    repeatType: type,
    repeatWeekdays: weekdays,
    repeatInterval: interval,
    repeatStartDate: start,
    isActive: true,
    createdAt: start,
    notificationMode: NotificationMode.none,
  );
}

DateTime d(int y, int m, int day) => DateTime(y, m, day);

HabitEntry _entry(DateTime date,
    {EntryStatus status = EntryStatus.done}) {
  return HabitEntry(
    id: 0,
    habitId: 1,
    date: date,
    status: status,
    createdAt: date,
    updatedAt: date,
  );
}

void main() {
  // -------------------------------------------------------------------------
  // doneDateKeys
  // -------------------------------------------------------------------------
  group('doneDateKeys', () {
    test('includes done and success, excludes skipped/failure', () {
      final entries = [
        _entry(d(2024, 1, 1), status: EntryStatus.done),
        _entry(d(2024, 1, 2), status: EntryStatus.success),
        _entry(d(2024, 1, 3), status: EntryStatus.skipped),
        _entry(d(2024, 1, 4), status: EntryStatus.failure),
      ];
      final keys = doneDateKeys(entries);
      expect(keys, {'2024-01-01', '2024-01-02'});
    });
  });

  // -------------------------------------------------------------------------
  // idealDays
  // -------------------------------------------------------------------------
  group('idealDays', () {
    test('everyDay → number of days inclusive', () {
      final h = _habit(startDate: d(2024, 1, 1));
      expect(idealDays(h, d(2024, 1, 1), d(2024, 1, 10)), 10);
    });

    test('selectedWeekdays Mon+Fri in one week → 2', () {
      final h = _habit(
        type: RepeatType.selectedWeekdays,
        startDate: d(2024, 1, 1),
        weekdays: [1, 5],
      );
      expect(idealDays(h, d(2024, 1, 1), d(2024, 1, 7)), 2);
    });
  });

  // -------------------------------------------------------------------------
  // currentStreak
  // -------------------------------------------------------------------------
  group('currentStreak', () {
    test('3 consecutive done days up to today → 3', () {
      final h = _habit(startDate: d(2024, 1, 1));
      final done = {'2024-01-08', '2024-01-09', '2024-01-10'};
      expect(currentStreak(h, done, d(2024, 1, 10)), 3);
    });

    test('breaks when most recent day missed → 0', () {
      final h = _habit(startDate: d(2024, 1, 1));
      final done = {'2024-01-08', '2024-01-09'}; // 10th missing
      expect(currentStreak(h, done, d(2024, 1, 10)), 0);
    });

    test('today before start → 0', () {
      final h = _habit(startDate: d(2024, 6, 1));
      expect(currentStreak(h, {}, d(2024, 1, 1)), 0);
    });

    test('selectedWeekdays counts only expected days', () {
      // Mon+Wed+Fri
      final h = _habit(
        type: RepeatType.selectedWeekdays,
        startDate: d(2024, 1, 1),
        weekdays: [1, 3, 5],
      );
      // Jan 1 Mon, 3 Wed, 5 Fri all done. Today = Fri Jan 5.
      final done = {'2024-01-01', '2024-01-03', '2024-01-05'};
      expect(currentStreak(h, done, d(2024, 1, 5)), 3);
    });
  });

  // -------------------------------------------------------------------------
  // bestStreak
  // -------------------------------------------------------------------------
  group('bestStreak', () {
    test('longest run found in middle', () {
      final h = _habit(startDate: d(2024, 1, 1));
      // done: 1,2,3 (gap) 5 (gap) 7,8,9,10
      final done = {
        '2024-01-01', '2024-01-02', '2024-01-03',
        '2024-01-05',
        '2024-01-07', '2024-01-08', '2024-01-09', '2024-01-10',
      };
      expect(bestStreak(h, done, d(2024, 1, 10)), 4);
    });

    test('no done days → 0', () {
      final h = _habit(startDate: d(2024, 1, 1));
      expect(bestStreak(h, {}, d(2024, 1, 10)), 0);
    });
  });

  // -------------------------------------------------------------------------
  // completionRate
  // -------------------------------------------------------------------------
  group('completionRate', () {
    test('half done → 0.5', () {
      final h = _habit(startDate: d(2024, 1, 1));
      final done = {'2024-01-01', '2024-01-02'}; // 2 of 4
      expect(completionRate(h, done, d(2024, 1, 1), d(2024, 1, 4)), 0.5);
    });

    test('no expected days → 0.0 (no NaN)', () {
      final h = _habit(
        type: RepeatType.selectedWeekdays,
        startDate: d(2024, 1, 1),
        weekdays: [7], // Sunday only
      );
      // Range Mon–Sat: no Sundays expected
      expect(completionRate(h, {}, d(2024, 1, 1), d(2024, 1, 6)), 0.0);
    });

    test('clamps from to habit start', () {
      final h = _habit(startDate: d(2024, 1, 5));
      // Range starts before habit; only Jan 5–7 expected (3 days)
      final done = {'2024-01-05', '2024-01-06', '2024-01-07'};
      expect(completionRate(h, done, d(2024, 1, 1), d(2024, 1, 7)), 1.0);
    });
  });

  // -------------------------------------------------------------------------
  // periodStats
  // -------------------------------------------------------------------------
  group('periodStats', () {
    test('aggregates expected/completed/missed', () {
      final h = _habit(startDate: d(2024, 1, 1));
      final entries = [
        _entry(d(2024, 1, 1)),
        _entry(d(2024, 1, 2)),
        _entry(d(2024, 1, 4)),
      ];
      final stats = periodStats(
        h,
        entries,
        d(2024, 1, 1),
        d(2024, 1, 5),
        d(2024, 1, 5),
      );
      expect(stats.expected, 5);
      expect(stats.completed, 3);
      expect(stats.missed, 2);
      expect(stats.completionRate, 0.6);
    });

    test('caps to today when range extends into future', () {
      final h = _habit(startDate: d(2024, 1, 1));
      final entries = [_entry(d(2024, 1, 1)), _entry(d(2024, 1, 2))];
      final stats = periodStats(
        h,
        entries,
        d(2024, 1, 1),
        d(2024, 1, 31), // future end
        d(2024, 1, 2), // today
      );
      expect(stats.expected, 2); // only Jan 1–2 counted
      expect(stats.completed, 2);
      expect(stats.completionRate, 1.0);
    });
  });
}
