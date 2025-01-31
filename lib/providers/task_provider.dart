import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pomidor/data/database/app_database.dart';
import 'package:pomidor/data/repository/task_repository.dart';

// Definicja StreamProvider
final taskListStreamProvider = StreamProvider<List<Task>>((ref) {
  final repository =
      ref.watch(taskRepositoryProvider); // Używamy ref.watch() do nasłuchiwania

  // Ustawienie początku dnia (godzina: 00:00:00)
  final startOfDay =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  final endOfDay = DateTime.now(); // Koniec dnia, czyli bieżący moment

  // Wywołanie metody watchTodayTasks z odpowiednimi datami
  return repository.watchTodayTasks(startOfDay, endOfDay);
});
