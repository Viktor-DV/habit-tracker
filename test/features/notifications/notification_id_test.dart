import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/features/notifications/domain/notification_orchestrator.dart';

/// The id packing is the one place where a silent bug (two reminders sharing
/// an id → one notification dropped) would go unnoticed. This asserts every
/// id we generate across the scheduling space is unique and within int range.
void main() {
  test('notification ids are unique across the scheduling space', () {
    final ids = <int>{};

    // Morning ids over the horizon.
    for (var day = 0; day < 7; day++) {
      expect(ids.add(morningNotificationId(day)), isTrue,
          reason: 'morning id collision at day $day');
    }

    // Individual ids: a realistic spread of habits/days/times/repeats.
    for (final habitId in [1, 2, 50, 199, 9999, 199999]) {
      for (var day = 0; day < 7; day++) {
        for (var ti = 0; ti < 20; ti++) {
          for (var rep = 0; rep <= 2; rep++) {
            final id = individualNotificationId(habitId, day, ti, rep);
            expect(ids.add(id), isTrue,
                reason: 'collision: habit=$habitId day=$day ti=$ti rep=$rep');
            // 32-bit signed range used by Android notification ids.
            expect(id, lessThan(2147483647));
            expect(id, greaterThanOrEqualTo(0));
          }
        }
      }
    }
  });

  test('reserved snooze slot does not collide with regular reminders', () {
    // snooze uses (off:0, timeIndex:9, repeat:9); regular timeIndex<... here
    // we only need it distinct from base reminders of the same habit/day.
    const habitId = 42;
    final snooze = individualNotificationId(habitId, 0, 9, 9);
    final regular = <int>{
      for (var ti = 0; ti < 9; ti++)
        for (var rep = 0; rep <= 2; rep++)
          individualNotificationId(habitId, 0, ti, rep),
    };
    expect(regular.contains(snooze), isFalse);
  });
}
