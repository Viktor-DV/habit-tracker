import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/features/notifications/data/notification_providers.dart';

/// Warning banner shown when notification permission is missing.
///
/// Tapping requests the OS permission (and exact-alarm permission).
///
/// ponytail: for the "permanently denied → open system settings" path we'd
/// need an intent dependency (android_intent_plus / app_settings). Deferred —
/// re-requesting covers the common first-run case without a new dependency.
class PermissionBanner extends ConsumerWidget {
  const PermissionBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final granted = ref.watch(notificationPermissionProvider);
    if (granted) return const SizedBox.shrink();

    return Material(
      color: const Color(0xFFFFF3E0),
      child: InkWell(
        onTap: () =>
            ref.read(notificationPermissionProvider.notifier).request(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              const Icon(Icons.notifications_off_outlined,
                  size: 20, color: Color(0xFFE65100)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Уведомления отключены',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: const Color(0xFFE65100),
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      'Нажмите, чтобы разрешить напоминания',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: const Color(0xFFE65100),
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right,
                  size: 18, color: Color(0xFFE65100)),
            ],
          ),
        ),
      ),
    );
  }
}
