import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/app/app_router.dart';
import 'package:habit_tracker/core/database/database_provider.dart';
import 'package:habit_tracker/core/notifications/notification_service.dart';
import 'package:habit_tracker/core/time/habit_day_resolver.dart';
import 'package:habit_tracker/features/habits/domain/habit_entry.dart';
import 'package:habit_tracker/features/habits/domain/habit_enums.dart';
import 'package:habit_tracker/features/notifications/data/notification_providers.dart';
import 'package:habit_tracker/features/settings/data/settings_repository.dart';

/// Handles a foreground notification response (tap or action button).
///
/// [fromLaunch] true means the app was cold-started by the tap, so we only
/// route (the schedule rebuild happens during normal startup anyway).
Future<void> handleNotificationResponse(
  ProviderContainer container,
  NotificationResponse response, {
  bool fromLaunch = false,
}) async {
  final payload = response.payload;
  final habitId = _habitIdFromPayload(payload);

  switch (response.actionId) {
    case kActionDone:
      if (habitId != null) await _markDone(container, habitId);
      return;
    case kActionSnooze:
      if (habitId != null) await _snooze(container, habitId);
      return;
    default:
      // Plain tap → open Home, highlight the habit if individual.
      if (habitId != null) {
        container.read(notificationHighlightProvider.notifier).set(habitId);
      }
      appRouter.go('/');
  }
}

int? _habitIdFromPayload(String? payload) {
  if (payload == null || !payload.startsWith('habit:')) return null;
  return int.tryParse(payload.substring('habit:'.length));
}

Future<void> _markDone(ProviderContainer container, int habitId) async {
  final repo = container.read(habitsRepositoryProvider);
  final habit = await repo.getById(habitId);
  if (habit == null) return;

  final settings = container.read(settingsProvider);
  final today = todayHabitDay(
    dayStartHour: settings.dayStartHour,
    dayStartMinute: settings.dayStartMinute,
  );
  final existing = await repo.getEntryForDate(habitId, today);
  final now = DateTime.now();
  await repo.upsertEntry(
    HabitEntry(
      id: existing?.id ?? 0,
      habitId: habitId,
      date: today,
      status: habit.habitKind == HabitKind.negative
          ? EntryStatus.success
          : EntryStatus.done,
      value: habit.targetValue,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    ),
  );

  // Cancel remaining reminders for today, then rebuild future schedule.
  final orchestrator = container.read(notificationOrchestratorProvider);
  await orchestrator.cancelForHabitToday(habitId, habit);
  await rebuildNotifications(container);
}

Future<void> _snooze(ProviderContainer container, int habitId) async {
  final repo = container.read(habitsRepositoryProvider);
  final habit = await repo.getById(habitId);
  if (habit == null) return;
  final settings = container.read(settingsProvider);
  final orchestrator = container.read(notificationOrchestratorProvider);
  await orchestrator.snooze(habit, settings.snoozeIntervalMinutes);
}
