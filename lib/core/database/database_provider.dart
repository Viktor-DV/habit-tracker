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
