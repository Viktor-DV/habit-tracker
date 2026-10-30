import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:habit_tracker/features/settings/domain/settings.dart';

// Keys
const _kDayStartHour = 'day_start_hour';
const _kDayStartMinute = 'day_start_minute';
const _kMorningSummary = 'morning_summary_enabled';
const _kSnoozeInterval = 'snooze_interval_minutes';
const _kDndMode = 'dnd_mode';
const _kDndUntil = 'dnd_until_ms';
const _kHistoryEnabled = 'history_enabled';

class SettingsRepository {
  SettingsRepository(this._prefs);

  final SharedPreferences _prefs;

  Settings load() {
    final dndModeStr = _prefs.getString(_kDndMode) ?? 'off';
    final dndUntilMs = _prefs.getInt(_kDndUntil);

    return Settings(
      dayStartHour: _prefs.getInt(_kDayStartHour) ?? 6,
      dayStartMinute: _prefs.getInt(_kDayStartMinute) ?? 0,
      morningSummaryEnabled: _prefs.getBool(_kMorningSummary) ?? true,
      snoozeIntervalMinutes: _prefs.getInt(_kSnoozeInterval) ?? 10,
      dndMode: _parseDndMode(dndModeStr),
      dndUntil: dndUntilMs != null
          ? DateTime.fromMillisecondsSinceEpoch(dndUntilMs)
          : null,
      historyEnabled: _prefs.getBool(_kHistoryEnabled) ?? true,
    );
  }

  Future<void> setDayStartTime(int hour, int minute) async {
    await _prefs.setInt(_kDayStartHour, hour);
    await _prefs.setInt(_kDayStartMinute, minute);
  }

  Future<void> setMorningSummaryEnabled(bool v) =>
      _prefs.setBool(_kMorningSummary, v);

  Future<void> setSnoozeInterval(int minutes) =>
      _prefs.setInt(_kSnoozeInterval, minutes);

  Future<void> setDndOff() async {
    await _prefs.setString(_kDndMode, 'off');
    await _prefs.remove(_kDndUntil);
  }

  Future<void> setDndForever() =>
      _prefs.setString(_kDndMode, 'forever');

  Future<void> setDndUntil(DateTime until) async {
    await _prefs.setString(_kDndMode, 'until');
    await _prefs.setInt(_kDndUntil, until.millisecondsSinceEpoch);
  }

  Future<void> setHistoryEnabled(bool v) =>
      _prefs.setBool(_kHistoryEnabled, v);

  static DndMode _parseDndMode(String s) => switch (s) {
        'forever' => DndMode.forever,
        'until' => DndMode.until,
        _ => DndMode.off,
      };
}

// ---------------------------------------------------------------------------
// Providers
// ---------------------------------------------------------------------------

/// Async provider that initialises SharedPreferences once.
final sharedPreferencesProvider =
    FutureProvider<SharedPreferences>((ref) => SharedPreferences.getInstance());

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider).requireValue;
  return SettingsRepository(prefs);
});

/// Notifier that holds Settings state and exposes mutation methods.
class SettingsNotifier extends Notifier<Settings> {
  @override
  Settings build() => ref.watch(settingsRepositoryProvider).load();

  SettingsRepository get _repo => ref.read(settingsRepositoryProvider);

  Future<void> setDayStartTime(int hour, int minute) async {
    await _repo.setDayStartTime(hour, minute);
    state = state.copyWith(dayStartHour: hour, dayStartMinute: minute);
  }

  Future<void> setMorningSummary(bool v) async {
    await _repo.setMorningSummaryEnabled(v);
    state = state.copyWith(morningSummaryEnabled: v);
  }

  Future<void> setSnoozeInterval(int minutes) async {
    await _repo.setSnoozeInterval(minutes);
    state = state.copyWith(snoozeIntervalMinutes: minutes);
  }

  Future<void> setDndOff() async {
    await _repo.setDndOff();
    state = state.copyWith(dndMode: DndMode.off, dndUntil: null);
  }

  Future<void> setDndForever() async {
    await _repo.setDndForever();
    state = state.copyWith(dndMode: DndMode.forever);
  }

  Future<void> setDndUntil(DateTime until) async {
    await _repo.setDndUntil(until);
    state = state.copyWith(dndMode: DndMode.until, dndUntil: until);
  }

  Future<void> setHistoryEnabled(bool v) async {
    await _repo.setHistoryEnabled(v);
    state = state.copyWith(historyEnabled: v);
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, Settings>(
  SettingsNotifier.new,
);
