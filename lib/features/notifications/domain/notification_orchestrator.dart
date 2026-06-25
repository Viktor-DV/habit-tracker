import 'package:habit_tracker/core/notifications/notification_service.dart';
import 'package:habit_tracker/core/time/expected_days_calculator.dart';
import 'package:habit_tracker/core/time/habit_day_resolver.dart';
import 'package:habit_tracker/features/habits/domain/habit.dart';
import 'package:habit_tracker/features/habits/domain/habit_entry.dart';
import 'package:habit_tracker/features/habits/domain/habit_enums.dart';
import 'package:habit_tracker/features/habits/domain/habits_repository.dart';
import 'package:habit_tracker/features/settings/domain/settings.dart';

/// How many days ahead we schedule concrete notifications.
/// Rebuilt on app open and on every relevant trigger, so 7 is plenty.
const int _horizonDays = 7;

/// Max automatic re-reminders after an individual time if not acted upon.
/// ponytail ceiling: local notifications can't read DB state to stop early,
/// so we cap follow-ups and rely on cancel-on-complete + daily rebuild.
const int _maxAutoRepeats = 2;

/// Notification id for the morning summary on a given day offset.
int morningNotificationId(int dayOffset) => 2000000000 + dayOffset;

/// Notification id for an individual reminder.
/// Packing: habitId*10000 + dayOffset*1000 + timeIndex*10 + repeat.
/// ponytail ceiling: assumes habitId < ~200k (autoincrement, fine for MVP),
/// dayOffset < 7, timeIndex < 100, repeat < 10 — kept disjoint from morning ids.
int individualNotificationId(
        int habitId, int dayOffset, int timeIndex, int repeat) =>
    habitId * 10000 + dayOffset * 1000 + timeIndex * 10 + repeat;

/// Rebuilds the full local-notification schedule from habits + settings.
///
/// Strategy: full teardown (`cancelAll`) then schedule concrete occurrences
/// over a rolling [_horizonDays] window. Uniform and correct for every repeat
/// type (uses [expectedDaysInRange] which already encodes smart distribution
/// for "N times per N days").
class NotificationOrchestrator {
  NotificationOrchestrator(this._service, this._repo);

  final NotificationService _service;
  final HabitsRepository _repo;

  int _morningId(int dayOffset) => morningNotificationId(dayOffset);
  int _individualId(int habitId, int dayOffset, int timeIndex, int repeat) =>
      individualNotificationId(habitId, dayOffset, timeIndex, repeat);

  // ---------------------------------------------------------------------------
  // Rebuild
  // ---------------------------------------------------------------------------

  Future<void> rebuild(Settings settings) async {
    await _service.cancelAll();

    // DND "forever" → silence everything.
    if (settings.dndMode == DndMode.forever) return;

    final today = todayHabitDay(
      dayStartHour: settings.dayStartHour,
      dayStartMinute: settings.dayStartMinute,
    );
    final horizonEnd = today.add(const Duration(days: _horizonDays - 1));

    final habits = (await _repo.getAll()).where((h) => h.isActive).toList();
    final snoozeMin = settings.snoozeIntervalMinutes;

    // Habits already completed today → skip today's individual reminders
    // (keeps rebuild idempotent so any trigger can just call rebuild()).
    final todayEntries = await _repo.getEntriesForRange(today, today);
    final completedToday = <int>{
      for (final HabitEntry e in todayEntries)
        if (e.status == EntryStatus.done || e.status == EntryStatus.success)
          e.habitId,
    };

    // ── Morning summary (one per day) ──────────────────────────────────────
    if (settings.morningSummaryEnabled) {
      for (var off = 0; off < _horizonDays; off++) {
        final day = today.add(Duration(days: off));
        final due = _summaryHabits(habits, day);
        if (due.isEmpty) continue;

        final when = DateTime(day.year, day.month, day.day,
            settings.dayStartHour, settings.dayStartMinute);
        if (_dndBlocks(settings, when)) continue;

        await _service.scheduleAt(
          id: _morningId(off),
          when: when,
          title: 'Привычки на сегодня',
          body: _summaryBody(due),
          payload: 'morning',
          isMorning: true,
        );
      }
    }

    // ── Individual reminders ───────────────────────────────────────────────
    for (final habit in habits) {
      if (habit.notificationMode != NotificationMode.dailyPlusIndividual) {
        continue;
      }
      if (habit.notificationTimes.isEmpty) continue;

      final expectedDays = expectedDaysInRange(habit, today, horizonEnd);
      for (final day in expectedDays) {
        final off = day.difference(today).inDays;
        if (off < 0 || off >= _horizonDays) continue;
        // Already done today → no more reminders for it today.
        if (off == 0 && completedToday.contains(habit.id)) continue;

        for (var ti = 0; ti < habit.notificationTimes.length; ti++) {
          final parsed = _parseHhMm(habit.notificationTimes[ti]);
          if (parsed == null) continue;
          final baseWhen = DateTime(
              day.year, day.month, day.day, parsed.$1, parsed.$2);

          // Base reminder + auto-repeats.
          for (var rep = 0; rep <= _maxAutoRepeats; rep++) {
            final when = baseWhen.add(Duration(minutes: snoozeMin * rep));
            if (when.day != baseWhen.day) break; // don't spill into next day
            if (_dndBlocks(settings, when)) continue;

            await _service.scheduleAt(
              id: _individualId(habit.id, off, ti, rep),
              when: when,
              title: habit.title,
              body: habit.description?.isNotEmpty == true
                  ? habit.description!
                  : 'Пора выполнить привычку',
              payload: 'habit:${habit.id}',
              withActions: true,
            );
          }
        }
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Cancel remaining reminders for a habit on the current day (on completion).
  // ---------------------------------------------------------------------------

  Future<void> cancelForHabitToday(int habitId, Habit habit) async {
    const off = 0; // today
    final maxTimes = habit.notificationTimes.length.clamp(1, 20);
    for (var ti = 0; ti < maxTimes; ti++) {
      for (var rep = 0; rep <= _maxAutoRepeats; rep++) {
        await _service.cancel(_individualId(habitId, off, ti, rep));
      }
    }
  }

  /// Schedules a single follow-up reminder [minutes] from now ("remind later").
  Future<void> snooze(Habit habit, int minutes) async {
    final when = DateTime.now().add(Duration(minutes: minutes));
    await _service.scheduleAt(
      id: _individualId(habit.id, 0, 9, 9), // reserved snooze slot
      when: when,
      title: habit.title,
      body: 'Напоминание',
      payload: 'habit:${habit.id}',
      withActions: true,
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Habits that should appear in the morning summary for [day].
  List<Habit> _summaryHabits(List<Habit> habits, DateTime day) {
    return habits.where((h) {
      if (h.notificationMode == NotificationMode.none) return false;
      // expected on that day?
      final expected = expectedDaysInRange(h, day, day);
      return expected.isNotEmpty;
    }).toList();
  }

  String _summaryBody(List<Habit> habits) {
    final names = habits.map((h) => h.title).take(5).toList();
    final extra = habits.length - names.length;
    final base = names.join(', ');
    return extra > 0 ? '$base и ещё $extra' : base;
  }

  /// True if a notification at [when] falls inside an active DND window.
  bool _dndBlocks(Settings s, DateTime when) {
    if (s.dndMode == DndMode.forever) return true;
    if (s.dndMode == DndMode.until && s.dndUntil != null) {
      return when.isBefore(s.dndUntil!);
    }
    return false;
  }

  (int, int)? _parseHhMm(String s) {
    final parts = s.split(':');
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return (h, m);
  }
}
