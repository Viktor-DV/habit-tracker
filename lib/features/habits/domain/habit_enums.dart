enum HabitKind { positive, negative }

enum CompletionType { yesNo, quantity, time, avoidance }

enum VisualType { icon, emoji, photo }

enum RepeatType { everyDay, selectedWeekdays, everyNDays, nTimesPerNDays }

enum NotificationMode { none, dailySummary, dailyPlusIndividual }

// Statuses stored in habit_entries
enum EntryStatus {
  // positive habits
  done,
  skipped,
  // negative habits
  success,
  failure,
  // negative also uses 'skipped'
}

extension HabitKindExt on HabitKind {
  String toDb() => name == 'positive' ? 'positive' : 'negative';
  static HabitKind fromDb(String s) =>
      s == 'positive' ? HabitKind.positive : HabitKind.negative;
}

extension CompletionTypeExt on CompletionType {
  String toDb() => switch (this) {
        CompletionType.yesNo => 'yes_no',
        CompletionType.quantity => 'quantity',
        CompletionType.time => 'time',
        CompletionType.avoidance => 'avoidance',
      };

  static CompletionType fromDb(String s) => switch (s) {
        'yes_no' => CompletionType.yesNo,
        'quantity' => CompletionType.quantity,
        'time' => CompletionType.time,
        'avoidance' => CompletionType.avoidance,
        _ => CompletionType.yesNo,
      };
}

extension VisualTypeExt on VisualType {
  String toDb() => name;
  static VisualType fromDb(String s) => switch (s) {
        'emoji' => VisualType.emoji,
        'photo' => VisualType.photo,
        _ => VisualType.icon,
      };
}

extension RepeatTypeExt on RepeatType {
  String toDb() => switch (this) {
        RepeatType.everyDay => 'every_day',
        RepeatType.selectedWeekdays => 'selected_weekdays',
        RepeatType.everyNDays => 'every_n_days',
        RepeatType.nTimesPerNDays => 'n_times_per_n_days',
      };

  static RepeatType fromDb(String s) => switch (s) {
        'selected_weekdays' => RepeatType.selectedWeekdays,
        'every_n_days' => RepeatType.everyNDays,
        'n_times_per_n_days' => RepeatType.nTimesPerNDays,
        _ => RepeatType.everyDay,
      };
}

extension NotificationModeExt on NotificationMode {
  String toDb() => switch (this) {
        NotificationMode.none => 'none',
        NotificationMode.dailySummary => 'daily_summary',
        NotificationMode.dailyPlusIndividual => 'daily_plus_individual',
      };

  static NotificationMode fromDb(String s) => switch (s) {
        'none' => NotificationMode.none,
        'daily_plus_individual' => NotificationMode.dailyPlusIndividual,
        _ => NotificationMode.dailySummary,
      };
}

extension EntryStatusExt on EntryStatus {
  String toDb() => name;
  static EntryStatus fromDb(String s) => switch (s) {
        'done' => EntryStatus.done,
        'skipped' => EntryStatus.skipped,
        'success' => EntryStatus.success,
        'failure' => EntryStatus.failure,
        _ => EntryStatus.skipped,
      };
}
