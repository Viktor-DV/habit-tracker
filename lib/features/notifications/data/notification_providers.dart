import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/core/database/database_provider.dart';
import 'package:habit_tracker/core/notifications/notification_service.dart';
import 'package:habit_tracker/features/notifications/domain/notification_orchestrator.dart';
import 'package:habit_tracker/features/settings/data/settings_repository.dart';

/// Single plugin instance.
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(FlutterLocalNotificationsPlugin());
});

final notificationOrchestratorProvider =
    Provider<NotificationOrchestrator>((ref) {
  return NotificationOrchestrator(
    ref.watch(notificationServiceProvider),
    ref.watch(habitsRepositoryProvider),
  );
});

/// Permission status, refreshable via [refresh].
class NotificationPermissionNotifier extends Notifier<bool> {
  @override
  bool build() => true; // optimistic until first check

  Future<void> refresh() async {
    final svc = ref.read(notificationServiceProvider);
    state = await svc.areNotificationsEnabled();
  }

  Future<void> request() async {
    final svc = ref.read(notificationServiceProvider);
    await svc.requestPermissions();
    await refresh();
  }
}

final notificationPermissionProvider =
    NotifierProvider<NotificationPermissionNotifier, bool>(
        NotificationPermissionNotifier.new);

/// Holds a habitId that the Home screen should scroll to / highlight,
/// set when the app is opened from an individual habit notification.
class NotificationHighlightNotifier extends Notifier<int?> {
  @override
  int? build() => null;
  void set(int? habitId) => state = habitId;
  void clear() => state = null;
}

final notificationHighlightProvider =
    NotifierProvider<NotificationHighlightNotifier, int?>(
        NotificationHighlightNotifier.new);

/// Rebuilds the whole notification schedule from current habits + settings.
/// Works with a [ProviderContainer] (startup / background handler) — screens
/// can call `ref.read(notificationOrchestratorProvider).rebuild(...)` directly.
Future<void> rebuildNotifications(ProviderContainer container) async {
  final orchestrator = container.read(notificationOrchestratorProvider);
  final settings = container.read(settingsProvider);
  await orchestrator.rebuild(settings);
}
