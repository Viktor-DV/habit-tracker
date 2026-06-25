import 'package:habit_tracker/core/database/app_database.dart';
import 'package:habit_tracker/features/habits/domain/habit.dart';
import 'package:habit_tracker/features/habits/domain/habit_entry.dart';
import 'package:habit_tracker/features/habits/domain/habits_repository.dart';
import 'habit_mapper.dart';

class HabitsRepositoryImpl implements HabitsRepository {
  const HabitsRepositoryImpl(this._db);

  final AppDatabase _db;

  // --- Habits ---

  @override
  Stream<List<Habit>> watchAll() =>
      _db.habitsDao.watchAll().map((rows) => rows.map(habitFromRow).toList());

  @override
  Future<List<Habit>> getAll() async {
    final rows = await _db.habitsDao.getAll();
    return rows.map(habitFromRow).toList();
  }

  @override
  Future<Habit?> getById(int id) async {
    final row = await _db.habitsDao.getById(id);
    return row == null ? null : habitFromRow(row);
  }

  @override
  Future<int> insert(Habit habit) async {
    final maxOrder = await _db.habitsDao.getMaxSortOrder();
    final companion = habitToCompanion(habit.copyWith(sortOrder: maxOrder + 1));
    return _db.habitsDao.insertHabit(companion);
  }

  @override
  Future<void> update(Habit habit) async {
    await _db.habitsDao.updateHabit(habitToCompanion(habit));
  }

  @override
  Future<void> delete(int id) async {
    await _db.habitsDao.deleteHabit(id);
  }

  // --- Entries ---

  @override
  Future<List<HabitEntry>> getEntriesForHabit(int habitId) async {
    final rows = await _db.entriesDao.getEntriesForHabit(habitId);
    return rows.map(entryFromRow).toList();
  }

  @override
  Future<List<HabitEntry>> getEntriesInRange(
    int habitId,
    DateTime from,
    DateTime to,
  ) async {
    final rows = await _db.entriesDao.getEntriesForHabitInRange(
      habitId,
      _fmt(from),
      _fmt(to),
    );
    return rows.map(entryFromRow).toList();
  }

  @override
  Future<HabitEntry?> getEntryForDate(int habitId, DateTime date) async {
    final row =
        await _db.entriesDao.getEntryForHabitOnDate(habitId, _fmt(date));
    return row == null ? null : entryFromRow(row);
  }

  @override
  Future<void> upsertEntry(HabitEntry entry) async {
    await _db.entriesDao.upsertEntry(entryToCompanion(entry));
  }

  @override
  Future<void> deleteEntry(int id) async {
    await _db.entriesDao.deleteEntry(id);
  }

  @override
  Future<void> deleteAllEntries(int habitId) async {
    await _db.entriesDao.deleteAllEntriesForHabit(habitId);
  }

  // --- Cross-habit range query ---

  @override
  Future<List<HabitEntry>> getEntriesForRange(DateTime from, DateTime to) async {
    final rows = await _db.entriesDao.getAllEntriesForDateRange(
      _fmt(from),
      _fmt(to),
    );
    return rows.map(entryFromRow).toList();
  }

  // --- History management ---

  @override
  Future<int> getTotalEntriesCount() => _db.entriesDao.getTotalCount();

  @override
  Future<void> deleteOldestEntries(int count) =>
      _db.entriesDao.deleteOldestN(count);

  @override
  Future<void> deleteAllEntriesGlobal() => _db.entriesDao.deleteAll();

  String _fmt(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}
