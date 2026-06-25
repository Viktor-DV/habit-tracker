part of 'app_database.dart';

@DriftAccessor(tables: [HabitEntries])
class EntriesDao extends DatabaseAccessor<AppDatabase> with _$EntriesDaoMixin {
  EntriesDao(super.db);

  Future<List<HabitEntryRow>> getEntriesForHabit(int habitId) =>
      (select(habitEntries)
            ..where((e) => e.habitId.equals(habitId))
            ..orderBy([(e) => OrderingTerm.asc(e.date)]))
          .get();

  Future<List<HabitEntryRow>> getEntriesForHabitInRange(
    int habitId,
    String fromDate,
    String toDate,
  ) =>
      (select(habitEntries)
            ..where(
              (e) =>
                  e.habitId.equals(habitId) &
                  e.date.isBiggerOrEqualValue(fromDate) &
                  e.date.isSmallerOrEqualValue(toDate),
            )
            ..orderBy([(e) => OrderingTerm.asc(e.date)]))
          .get();

  // Get all entries for a specific date across all habits
  Future<List<HabitEntryRow>> getEntriesForDate(String date) =>
      (select(habitEntries)..where((e) => e.date.equals(date))).get();

  // Get all entries in a date range across all habits (for calendar dots)
  Future<List<HabitEntryRow>> getAllEntriesForDateRange(
    String fromDate,
    String toDate,
  ) =>
      (select(habitEntries)
            ..where(
              (e) =>
                  e.date.isBiggerOrEqualValue(fromDate) &
                  e.date.isSmallerOrEqualValue(toDate),
            ))
          .get();

  Future<HabitEntryRow?> getEntryForHabitOnDate(
    int habitId,
    String date,
  ) =>
      (select(habitEntries)
            ..where((e) => e.habitId.equals(habitId) & e.date.equals(date)))
          .getSingleOrNull();

  Stream<List<HabitEntryRow>> watchEntriesForHabit(int habitId) =>
      (select(habitEntries)
            ..where((e) => e.habitId.equals(habitId))
            ..orderBy([(e) => OrderingTerm.asc(e.date)]))
          .watch();

  Future<int> insertEntry(HabitEntriesCompanion companion) =>
      into(habitEntries).insert(companion);

  Future<bool> updateEntry(HabitEntriesCompanion companion) =>
      update(habitEntries).replace(companion);

  Future<int> upsertEntry(HabitEntriesCompanion companion) =>
      into(habitEntries).insertOnConflictUpdate(companion);

  Future<int> deleteEntry(int id) =>
      (delete(habitEntries)..where((e) => e.id.equals(id))).go();

  Future<int> deleteAllEntriesForHabit(int habitId) =>
      (delete(habitEntries)..where((e) => e.habitId.equals(habitId))).go();

  // For history management (auto-cleanup, user cleanup)
  Future<int> getTotalCount() async {
    final count = habitEntries.id.count();
    final query = selectOnly(habitEntries)..addColumns([count]);
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  // Delete oldest N entries
  Future<void> deleteOldestN(int n) async {
    final oldest = await (select(habitEntries)
          ..orderBy([(e) => OrderingTerm.asc(e.date)])
          ..limit(n))
        .get();
    final ids = oldest.map((e) => e.id).toList();
    if (ids.isNotEmpty) {
      await (delete(habitEntries)
            ..where((e) => e.id.isIn(ids)))
          .go();
    }
  }

  Future<int> deleteAll() => delete(habitEntries).go();
}
