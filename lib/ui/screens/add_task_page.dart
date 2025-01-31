import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomidor/providers/add_task_provider.dart';

class AddTaskPage extends ConsumerStatefulWidget {
  const AddTaskPage({
    super.key,
    required this.onAddTask,
  });

  final void Function(String title, int pomodoroCount) onAddTask;

  @override
  ConsumerState<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends ConsumerState<AddTaskPage> {
  final _titleController = TextEditingController();
  int _pomodoroCount = 1;
  final _formKey = GlobalKey<FormState>();

  void _incrementPomodoro() {
    setState(() {
      _pomodoroCount++;
    });
  }

  void _decrementPomodoro() {
    if (_pomodoroCount > 1) {
      setState(() {
        _pomodoroCount--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final addTaskState = ref.watch(addTaskProvider);
    ref.listen<AddTaskState>(addTaskProvider, (previous, next) {
      if (next.isSuccess) {
        // Jeśli zadanie zostało pomyślnie dodane, wracamy do poprzedniego ekranu
        Navigator.pop(context);
      } else if (next.isError) {
        // Jeśli wystąpił błąd, pokazujemy komunikat o błędzie
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Błąd przy dodawaniu zadania!')),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dodaj zadanie'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Nazwa zadania",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Podaj nazwę zadania!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text('Ilość sesji'),
              Card(
                elevation: 2,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: _decrementPomodoro,
                        icon: const Icon(Icons.remove),
                      ),
                      Text(
                        '$_pomodoroCount',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: _incrementPomodoro,
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                    const Size(double.infinity, 48),
                  ),
                ),
                onPressed: addTaskState.isLoading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          // Wywołanie metody addTask przy pomocy provider'a
                          ref.read(addTaskProvider.notifier).addTask(
                                _titleController.text,
                                _pomodoroCount,
                              );
                        }
                      },
                child: Text(addTaskState.isLoading ? 'Zapisywanie' : 'Zapisz'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
