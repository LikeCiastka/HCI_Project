import 'package:pomidor/data/database/app_database.dart';
import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod/riverpod.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return TaskRepository(database);
});

class TaskRepository {
  final AppDatabase _appDatabase;

  TaskRepository(this._appDatabase);

  /// Pobierz wszystkie zadania
  Future<List<Task>> getAllTasks() async {
    return await _appDatabase.getAllTasks();
  }

  /// Utwórz nowe zadanie
  Future<int> createTask(String title, int pomodoroCount) async {
    return await _appDatabase.createTask(
      TasksCompanion.insert(
        title: title,
        pomodoroCount: Value(pomodoroCount),
      ),
    );
  }

  /// Metoda do obserwowania zadań z dzisiejszego dnia
  Stream<List<Task>> watchTodayTasks(DateTime start, DateTime end) {
    final query = _appDatabase.select(_appDatabase.tasks)
      ..where((t) => t.createdAt.isBetween(Variable(start), Variable(end)));

    return query.watch();
  }
}
