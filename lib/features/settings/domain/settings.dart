/// Immutable snapshot of all app settings.
class Settings {
  const Settings({
    this.dayStartHour = 6,
    this.dayStartMinute = 0,
    this.morningSummaryEnabled = true,
    this.snoozeIntervalMinutes = 10,
    this.dndMode = DndMode.off,
    this.dndUntil,
    this.historyEnabled = true,
    this.premiumCachedStatus = false,
  });

  /// Hour at which the app considers a new habit-day to start (default 06:00).
  final int dayStartHour;
  final int dayStartMinute;

  final bool morningSummaryEnabled;

  /// Minutes for snooze / "remind later" / auto-repeat.
  final int snoozeIntervalMinutes;

  final DndMode dndMode;

  /// Non-null only when [dndMode] is [DndMode.until].
  final DateTime? dndUntil;

  final bool historyEnabled;

  /// Locally cached Premium status for fast offline start.
  final bool premiumCachedStatus;

  Settings copyWith({
    int? dayStartHour,
    int? dayStartMinute,
    bool? morningSummaryEnabled,
    int? snoozeIntervalMinutes,
    DndMode? dndMode,
    DateTime? dndUntil,
    bool? historyEnabled,
    bool? premiumCachedStatus,
  }) {
    return Settings(
      dayStartHour: dayStartHour ?? this.dayStartHour,
      dayStartMinute: dayStartMinute ?? this.dayStartMinute,
      morningSummaryEnabled:
          morningSummaryEnabled ?? this.morningSummaryEnabled,
      snoozeIntervalMinutes:
          snoozeIntervalMinutes ?? this.snoozeIntervalMinutes,
      dndMode: dndMode ?? this.dndMode,
      dndUntil: dndUntil ?? this.dndUntil,
      historyEnabled: historyEnabled ?? this.historyEnabled,
      premiumCachedStatus: premiumCachedStatus ?? this.premiumCachedStatus,
    );
  }
}

enum DndMode {
  /// Notifications are not silenced.
  off,

  /// Notifications silenced indefinitely until user turns off manually.
  forever,

  /// Notifications silenced until [Settings.dndUntil].
  until,
}
