import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_tracker/l10n/l10n.dart';

class AppShellScreen extends ConsumerWidget {
  const AppShellScreen({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  static const _tabs = [
    (icon: Icons.calendar_today_outlined, route: '/'),
    (icon: Icons.checklist_outlined, route: '/habits'),
    (icon: Icons.bar_chart_outlined, route: '/statistics'),
    (icon: Icons.settings_outlined, route: '/settings'),
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
      floatingActionButton: navigationShell.currentIndex == 3
          ? null
          : _CreateFab(navigationShell: navigationShell),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

/// FAB that opens the habit creation flow.
class _CreateFab extends ConsumerWidget {
  const _CreateFab({required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      heroTag: 'create_habit_fab',
      onPressed: () => context.push('/habits/create'),
      tooltip: context.l10n.fabCreateHabit,
      child: const Icon(Icons.add, size: 28),
    );
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
          destinations: [
            for (var i = 0; i < AppShellScreen._tabs.length; i++)
              NavigationDestination(
                icon: Icon(AppShellScreen._tabs[i].icon),
                label: [
                  context.l10n.navHome,
                  context.l10n.navHabits,
                  context.l10n.navStats,
                  context.l10n.navSettings,
                ][i],
              ),
          ],
        ),
      ],
    );
  }
}
