import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider_android/path_provider_android.dart';

part 'app_database.g.dart';
part 'habits_dao.dart';
part 'entries_dao.dart';

// ---------------------------------------------------------------------------
// Tables
// ---------------------------------------------------------------------------

@DataClassName('HabitRow')
class Habits extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();

  // 'positive' | 'negative'
  TextColumn get habitKind => text()();

  // 'yes_no' | 'quantity' | 'time' | 'avoidance'
  TextColumn get completionType => text()();

  // 'icon' | 'emoji' | 'photo'
  TextColumn get visualType => text().withDefault(const Constant('icon'))();
  TextColumn get iconName => text().nullable()();
  TextColumn get emoji => text().nullable()();
  TextColumn get photoPath => text().nullable()();

  IntColumn get colorValue => integer()();

  RealColumn get targetValue => real().nullable()();
  TextColumn get targetUnit => text().nullable()();

  // 'every_day' | 'selected_weekdays' | 'every_n_days' | 'n_times_per_n_days'
  TextColumn get repeatType => text()();

  // JSON: [1,3,5]  (1=Mon … 7=Sun) — for selected_weekdays
  TextColumn get repeatDaysJson => text().nullable()();

  // For every_n_days
  IntColumn get repeatInterval => integer().nullable()();

  // For n_times_per_n_days
  IntColumn get repeatGoalCount => integer().nullable()();
  IntColumn get repeatPeriodDays => integer().nullable()();

  // 'YYYY-MM-DD'
  TextColumn get repeatStartDate => text()();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  // Unix milliseconds
  IntColumn get createdAt => integer()();

  // 'none' | 'daily_summary' | 'daily_plus_individual'
  TextColumn get notificationMode =>
      text().withDefault(const Constant('daily_summary'))();

  // JSON: ["09:00","20:00"]
  TextColumn get notificationTimesJson => text().nullable()();

  BoolColumn get timerEnabled =>
      boolean().withDefault(const Constant(false))();

  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

@DataClassName('HabitEntryRow')
class HabitEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get habitId =>
      integer().references(Habits, #id, onDelete: KeyAction.cascade)();

  // 'YYYY-MM-DD'
  TextColumn get date => text()();

  // positive: 'done' | 'skipped'
  // negative: 'success' | 'failure' | 'skipped'
  TextColumn get status => text()();

  RealColumn get value => real().nullable()();

  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
}

// ---------------------------------------------------------------------------
// Database
// ---------------------------------------------------------------------------

@DriftDatabase(tables: [Habits, HabitEntries], daos: [HabitsDao, EntriesDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          // Enable foreign key enforcement
          await customStatement('PRAGMA foreign_keys = ON');
        },
        onUpgrade: (m, from, to) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // Android-only: path_provider_android avoids pulling in objective_c (iOS)
    final dirPath = await PathProviderAndroid().getApplicationDocumentsPath();
    final file = File(p.join(dirPath!, 'habit_tracker.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
