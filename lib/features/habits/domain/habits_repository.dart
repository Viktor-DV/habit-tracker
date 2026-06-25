import 'habit.dart';
import 'habit_entry.dart';

abstract interface class HabitsRepository {
  // --- Habits ---
  Stream<List<Habit>> watchAll();
  Future<List<Habit>> getAll();
  Future<Habit?> getById(int id);
  Future<int> insert(Habit habit);
  Future<void> update(Habit habit);
  Future<void> delete(int id);

  // --- Entries ---
  Future<List<HabitEntry>> getEntriesForHabit(int habitId);
  Future<List<HabitEntry>> getEntriesInRange(
    int habitId,
    DateTime from,
    DateTime to,
  );
  Future<HabitEntry?> getEntryForDate(int habitId, DateTime date);
  Future<void> upsertEntry(HabitEntry entry);
  Future<void> deleteEntry(int id);
  Future<void> deleteAllEntries(int habitId);

  // --- Cross-habit range query ---
  /// All entries across all habits in [from]..[to] (inclusive).
  Future<List<HabitEntry>> getEntriesForRange(DateTime from, DateTime to);

  // --- History management ---
  Future<int> getTotalEntriesCount();
  Future<void> deleteOldestEntries(int count);
  Future<void> deleteAllEntriesGlobal();
}
