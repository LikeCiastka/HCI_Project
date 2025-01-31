import 'package:drift/drift.dart';
import 'package:pomidor/data/database/app_database.dart';

class TaskRepository {
  final AppDatabase _database;

  TaskRepository(this._database);

  // Pobierz wszystkie zadania
  Future<List<Task>> getAllTasks() async {
    return await _database.select(_database.tasks).get();
  }

  // Stream dla zadań na dany dzień
  Stream<List<Task>> watchTodayTasks(DateTime start, DateTime end) {
    final query = _database.select(_database.tasks);
    query.where((t) => t.createdAt.isBetween(Variable(start), Variable(end)));
    return query.watch();
  }

  // Dodaj nowe zadanie
  Future<void> addTask(String title, int pomodoroCount) async {
    // Tworzenie nowego zadania
    final taskCompanion = TasksCompanion.insert(
      title: title,
      pomodoroCount: Value(pomodoroCount),
      createdAt: Value(DateTime.now()), // Dodanie daty utworzenia
    );

    // Dodanie zadania do bazy danych
    await _database.into(_database.tasks).insert(taskCompanion);
  }
}
