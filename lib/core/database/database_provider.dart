import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/core/database/app_database.dart';
import 'package:habit_tracker/features/habits/data/habits_repository_impl.dart';
import 'package:habit_tracker/features/habits/domain/habits_repository.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final habitsRepositoryProvider = Provider<HabitsRepository>((ref) {
  return HabitsRepositoryImpl(ref.watch(appDatabaseProvider));
});

/// Bumped on any habit create/edit/delete/reorder/toggle so that kept-alive
/// autoDispose list & stats providers refetch. The Home tab lives inside an
/// IndexedStack (StatefulShellRoute), so its providers stay alive and would
/// otherwise show stale data until an app restart.
///
/// Mutation sites bump it via:
///   ref.read(habitsRevisionProvider.notifier).bump();
class HabitsRevision extends Notifier<int> {
  @override
  int build() => 0;

  void bump() => state++;
}

final habitsRevisionProvider =
    NotifierProvider<HabitsRevision, int>(HabitsRevision.new);
