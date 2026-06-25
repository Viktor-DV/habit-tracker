import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:habit_tracker/app/app.dart';
import 'package:habit_tracker/features/notifications/data/notification_handler.dart';
import 'package:habit_tracker/features/notifications/data/notification_providers.dart';
import 'package:habit_tracker/features/settings/data/settings_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Pre-load SharedPreferences so settingsProvider is sync on first access.
  final prefs = await SharedPreferences.getInstance();

  // Shared container so pre-runApp init and the widget tree use one state.
  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(AsyncValue.data(prefs)),
    ],
  );

  final service = container.read(notificationServiceProvider);
  await service.init(
    onResponse: (response) => handleNotificationResponse(container, response),
  );

  await container.read(notificationPermissionProvider.notifier).refresh();

  // If launched by tapping a notification, route accordingly.
  final launch = await service.launchPayload();
  if (launch != null) {
    await handleNotificationResponse(container, launch, fromLaunch: true);
  }

  // Rebuild the schedule on every cold start (covers reboot + edits offline).
  await rebuildNotifications(container);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const App(),
    ),
  );
}
