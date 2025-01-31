import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  IntColumn get duration => integer().withDefault(const Constant(1500))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  BoolColumn get isDone => boolean().withDefault(const Constant(false))();
  IntColumn get pomodoroCount => integer().withDefault(const Constant(0))();
}

@DriftDatabase(tables: [Tasks])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  /// Pobierz wszystkie zadania
  Future<List<Task>> getAllTasks() => select(tasks).get();

  /// Utwórz nowe zadanie
  Future<int> createTask(TasksCompanion task) => into(tasks).insert(task);

  /// Zaktualizuj zadanie
  Future<bool> updateTask(Task task) => update(tasks).replace(task);

  /// Usuń zadanie
  Future<int> deleteTask(int id) =>
      (delete(tasks)..where((t) => t.id.equals(id))).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbDir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbDir.path, 'db.sqlite'));

    return NativeDatabase(file);
  });
}
