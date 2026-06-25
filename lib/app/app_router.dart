import 'package:go_router/go_router.dart';
import 'package:habit_tracker/features/app_shell/presentation/app_shell_screen.dart';
import 'package:habit_tracker/features/habits/domain/habit.dart';
import 'package:habit_tracker/features/habits/domain/habit_templates.dart';
import 'package:habit_tracker/features/habits/presentation/all_habits_screen.dart';
import 'package:habit_tracker/features/habits/presentation/habit_detail_screen.dart';
import 'package:habit_tracker/features/habits/presentation/habit_form_screen.dart';
import 'package:habit_tracker/features/habits/presentation/home_screen.dart';
import 'package:habit_tracker/features/habits/presentation/template_picker_screen.dart';
import 'package:habit_tracker/features/monetization/presentation/paywall_screen.dart';
import 'package:habit_tracker/features/settings/presentation/settings_screen.dart';
import 'package:habit_tracker/features/statistics/presentation/statistics_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) =>
          AppShellScreen(navigationShell: shell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: '/', builder: (_, _) => const HomeScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/habits',
            builder: (_, _) => const AllHabitsScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/statistics',
            builder: (_, _) => const StatisticsScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/settings',
            builder: (_, _) => const SettingsScreen(),
          ),
        ]),
      ],
    ),

    // Template picker — FAB entry point
    GoRoute(
      path: '/habits/create',
      builder: (_, _) => const TemplatePickerScreen(),
    ),

    // Habit form — create (with optional template in extra)
    GoRoute(
      path: '/habits/new',
      builder: (context, state) {
        final template = state.extra as HabitTemplate?;
        return HabitFormScreen(template: template);
      },
    ),

    // Habit form — edit (Habit object passed via extra)
    GoRoute(
      path: '/habits/edit',
      builder: (context, state) {
        final habit = state.extra as Habit;
        return HabitFormScreen(editHabit: habit);
      },
    ),

    // Habit detail screen
    GoRoute(
      path: '/habits/detail',
      builder: (context, state) {
        final habit = state.extra as Habit;
        return HabitDetailScreen(habit: habit);
      },
    ),

    // Paywall
    GoRoute(
      path: '/paywall',
      builder: (_, _) => const PaywallScreen(),
    ),
  ],
);
