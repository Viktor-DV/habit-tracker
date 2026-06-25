import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Action button ids used in notifications.
const String kActionDone = 'action_done';
const String kActionSnooze = 'action_snooze';

/// Channel ids.
const String _kMorningChannel = 'morning_summary';
const String _kHabitChannel = 'habit_reminders';

/// Thin wrapper around flutter_local_notifications.
///
/// Owns plugin init, timezone setup, permission requests and the low-level
/// schedule / cancel primitives. All habit-domain logic lives in the
/// NotificationOrchestrator — this class knows nothing about habits.
class NotificationService {
  NotificationService(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;

  bool _tzReady = false;

  AndroidFlutterLocalNotificationsPlugin? get _android =>
      _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  /// Initializes timezone DB + plugin. Safe to call once at startup.
  Future<void> init({
    DidReceiveNotificationResponseCallback? onResponse,
  }) async {
    await _ensureTimezone();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _android?.initialize(
      settings: androidInit,
      onDidReceiveNotificationResponse: onResponse,
      onDidReceiveBackgroundNotificationResponse: _backgroundResponseHandler,
    );
  }

  Future<void> _ensureTimezone() async {
    if (_tzReady) return;
    tzdata.initializeTimeZones();
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } catch (_) {
      // ponytail: fall back to UTC if the platform can't report a zone.
      // Reminders then fire on UTC wall-clock — acceptable degraded mode.
      tz.setLocalLocation(tz.getLocation('UTC'));
    }
    _tzReady = true;
  }

  /// The app launch details — non-null payload means app was opened by a tap.
  Future<NotificationResponse?> launchPayload() async {
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp ?? false) {
      return details!.notificationResponse;
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // Permissions
  // ---------------------------------------------------------------------------

  Future<bool> requestPermissions() async {
    final android = _android;
    if (android == null) return false;
    final notif = await android.requestNotificationsPermission() ?? false;
    // Exact-alarm prompt only matters on Android 12+; ignore result here.
    await android.requestExactAlarmsPermission();
    return notif;
  }

  Future<bool> areNotificationsEnabled() async =>
      await _android?.areNotificationsEnabled() ?? false;

  Future<bool> canScheduleExactAlarms() async =>
      await _android?.canScheduleExactNotifications() ?? false;

  // ---------------------------------------------------------------------------
  // Scheduling primitives
  // ---------------------------------------------------------------------------

  /// Schedules a one-shot exact notification at [when] (local time).
  /// Past [when] is silently skipped.
  Future<void> scheduleAt({
    required int id,
    required DateTime when,
    required String title,
    required String body,
    String? payload,
    bool isMorning = false,
    bool withActions = false,
  }) async {
    await _ensureTimezone();
    final scheduled = tz.TZDateTime.from(when, tz.local);
    if (scheduled.isBefore(tz.TZDateTime.now(tz.local))) return;

    final android = AndroidNotificationDetails(
      isMorning ? _kMorningChannel : _kHabitChannel,
      isMorning ? 'Утренняя сводка' : 'Напоминания о привычках',
      channelDescription:
          isMorning ? 'Сводка привычек на день' : 'Напоминания по привычкам',
      importance: Importance.max,
      priority: Priority.high,
      actions: withActions
          ? const [
              AndroidNotificationAction(kActionDone, 'Выполнено',
                  showsUserInterface: false, cancelNotification: true),
              AndroidNotificationAction(kActionSnooze, 'Напомнить позже',
                  showsUserInterface: false, cancelNotification: true),
            ]
          : null,
    );

    await _android?.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduled,
      notificationDetails: android,
      scheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
  }

  Future<void> cancel(int id) async => _android?.cancel(id: id);
  Future<void> cancelAll() async => _android?.cancelAll();

  Future<List<PendingNotificationRequest>> pending() async =>
      await _android?.pendingNotificationRequests() ?? const [];
}

/// Background isolate handler. Runs without access to Riverpod/DB.
///
/// ponytail: deliberately minimal. The OS already cancels the posted
/// notification (cancelNotification: true on the actions). Acting on "Done" /
/// "Snooze" requires DB + reschedule, which we do on next app open instead of
/// spinning up a DB connection in a throwaway isolate.
@pragma('vm:entry-point')
void _backgroundResponseHandler(NotificationResponse response) {
  if (kDebugMode) {
    debugPrint('bg notification action: ${response.actionId}');
  }
}
