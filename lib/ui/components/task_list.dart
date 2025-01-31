import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pomidor/providers/todays_tasks_provider.dart';
import 'package:pomidor/ui/screens/add_task_page.dart';
import 'package:pomidor/ui/screens/timer_screen.dart';
import 'package:pomidor/ui/components/task_card.dart';

class TaskList extends ConsumerWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(todayTasksProvider);

    return tasksAsync.when(
      data: (tasks) {
        if (tasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.task_alt_outlined,
                  size: 40,
                ),
                const SizedBox(height: 10),
                const Text("Nie ma zadań na dziś"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddTaskPage(
                          onAddTask: (title, pomodoroCount) {
                            print(
                                'Dodano zadanie: $title, Pomodoros: $pomodoroCount');
                          },
                        ),
                      ),
                    );
                  },
                  child: const Text("Dodaj zadanie"),
                ),
              ],
            ),
          );
        }
        return ListView.separated(
          itemBuilder: (context, index) => TaskCard(
            task: tasks[index],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TimerScreen(task: tasks[index]),
                ),
              );
            },
          ),
          itemCount: tasks.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Text('Wystąpił błąd: $error'),
      ),
    );
  }
}
