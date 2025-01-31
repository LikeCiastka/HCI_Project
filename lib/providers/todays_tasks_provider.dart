import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pomidor/data/database/app_database.dart';
import 'package:pomidor/data/repository/task_repository.dart';

final todayTasksProvider = StreamProvider<List<Task>>((ref) async* {
  final taskRepository = ref.read(taskRepositoryProvider);
  final today = DateTime.now();
  final startOfDay = DateTime(today.year, today.month, today.day);
  final endOfDay = startOfDay.add(const Duration(days: 1));
  yield* taskRepository.watchTodayTasks(startOfDay, endOfDay);
});
