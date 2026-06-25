import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/core/database/database_provider.dart';
import 'package:habit_tracker/features/habits/domain/habit.dart';
import 'package:habit_tracker/features/habits/domain/habit_entry.dart';
import 'package:habit_tracker/features/habits/domain/habit_enums.dart';

/// Upserts a [HabitEntry] for [habit] on the current [date].
/// Call [onInvalidate] after to refresh any dependent providers.
Future<void> saveEntry(
  WidgetRef ref,
  Habit habit,
  HabitEntry? existing,
  DateTime date, {
  required EntryStatus status,
  double? value,
  required void Function() onInvalidate,
}) async {
  final repo = ref.read(habitsRepositoryProvider);
  final now = DateTime.now();
  final entry = HabitEntry(
    id: existing?.id ?? 0,
    habitId: habit.id,
    date: date,
    status: status,
    value: value,
    createdAt: existing?.createdAt ?? now,
    updatedAt: now,
  );
  await repo.upsertEntry(entry);
  onInvalidate();
}
