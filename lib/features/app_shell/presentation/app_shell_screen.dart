import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_tracker/core/database/database_provider.dart';
import 'package:habit_tracker/features/monetization/data/monetization_providers.dart';

class AppShellScreen extends ConsumerWidget {
  const AppShellScreen({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  static const _tabs = [
    (icon: Icons.calendar_today_outlined, label: 'Главная', route: '/'),
    (icon: Icons.checklist_outlined, label: 'Привычки', route: '/habits'),
    (icon: Icons.bar_chart_outlined, label: 'Статистика', route: '/statistics'),
    (icon: Icons.settings_outlined, label: 'Настройки', route: '/settings'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: _BottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: (i) => navigationShell.goBranch(
          i,
          initialLocation: i == navigationShell.currentIndex,
        ),
      ),
      floatingActionButton: _CreateFab(navigationShell: navigationShell),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

/// FAB that enforces the Free-tier 5-habit limit.
class _CreateFab extends ConsumerWidget {
  const _CreateFab({required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      heroTag: 'create_habit_fab',
      onPressed: () => _onCreate(context, ref),
      tooltip: 'Создать привычку',
      child: const Icon(Icons.add, size: 28),
    );
  }

  Future<void> _onCreate(BuildContext context, WidgetRef ref) async {
    final isPremium = ref.read(isPremiumProvider);
    if (!isPremium) {
      final repo = ref.read(habitsRepositoryProvider);
      final all = await repo.getAll();
      if (all.length >= kFreeHabitLimit) {
        if (context.mounted) context.push('/paywall');
        return;
      }
    }
    if (context.mounted) context.push('/habits/create');
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(height: 1, thickness: 1),
        NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: onTap,
          destinations: AppShellScreen._tabs
              .map(
                (t) => NavigationDestination(
                  icon: Icon(t.icon),
                  label: t.label,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
