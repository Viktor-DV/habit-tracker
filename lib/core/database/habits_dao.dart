part of 'app_database.dart';

@DriftAccessor(tables: [Habits])
class HabitsDao extends DatabaseAccessor<AppDatabase> with _$HabitsDaoMixin {
  HabitsDao(super.db);

  // Watch all habits ordered by sort_order
  Stream<List<HabitRow>> watchAll() =>
      (select(habits)..orderBy([(h) => OrderingTerm.asc(h.sortOrder)])).watch();

  Future<List<HabitRow>> getAll() =>
      (select(habits)..orderBy([(h) => OrderingTerm.asc(h.sortOrder)])).get();

  Future<HabitRow?> getById(int id) =>
      (select(habits)..where((h) => h.id.equals(id))).getSingleOrNull();

  Future<int> insertHabit(HabitsCompanion companion) =>
      into(habits).insert(companion);

  Future<bool> updateHabit(HabitsCompanion companion) =>
      update(habits).replace(companion);

  Future<int> deleteHabit(int id) =>
      (delete(habits)..where((h) => h.id.equals(id))).go();

  // Get max sort_order to append new habits at the end
  Future<int> getMaxSortOrder() async {
    final expr = habits.sortOrder.max();
    final query = selectOnly(habits)..addColumns([expr]);
    final row = await query.getSingle();
    return row.read(expr) ?? 0;
  }
}
