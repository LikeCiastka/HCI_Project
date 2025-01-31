import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pomidor/data/repository/task_repository.dart';

class AddTaskState {
  final bool isLoading;
  final bool isSuccess;
  final bool isError;

  AddTaskState({
    this.isLoading = false,
    this.isSuccess = false,
    this.isError = false,
  });

  AddTaskState copyWith({
    bool? isLoading,
    bool? isSuccess,
    bool? isError,
  }) {
    return AddTaskState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isError: isError ?? this.isError,
    );
  }
}

// Tworzenie provider'a dla AddTaskNotifier z AutoDispose
final addTaskProvider =
    AutoDisposeStateNotifierProvider<AddTaskNotifier, AddTaskState>((ref) {
  final taskRepository = ref.watch(taskRepositoryProvider);
  return AddTaskNotifier(taskRepository);
});

// Notifier, który obsługuje dodawanie zadania
class AddTaskNotifier extends StateNotifier<AddTaskState> {
  final TaskRepository _taskRepository;

  AddTaskNotifier(this._taskRepository) : super(AddTaskState());

  // Funkcja do dodawania zadania
  Future<void> addTask(String title, int pomodoroCount) async {
    try {
      state = state.copyWith(isLoading: true); // Ustawienie ładowania na true

      final taskId = await _taskRepository.createTask(title, pomodoroCount);

      if (taskId > 0) {
        state =
            state.copyWith(isLoading: false, isSuccess: true); // Zadanie dodane
      } else {
        state = state.copyWith(isLoading: false, isError: true); // Błąd
      }
    } catch (e) {
      state = state.copyWith(
          isLoading: false, isError: true); // Błąd w przypadku wyjątku
      rethrow;
    }
  }
}
