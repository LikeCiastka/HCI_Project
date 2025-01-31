import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomidor/ui/components/task_list.dart';
import 'package:pomidor/ui/components/today_summary.dart';
import 'package:pomidor/ui/screens/add_task_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF007BFF), Color(0xFF00A8E8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/logo.jpg', height: 35),
            const SizedBox(width: 10),
            Text(
              'Timer UKW',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: FloatingActionButton(
          backgroundColor: Colors.amber,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          elevation: 10,
          splashColor: Colors.orangeAccent,
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTaskPage(
                  onAddTask: (title, pomodoroCount) {
                    print('Title: $title, Pomodoro Count: $pomodoroCount');
                  },
                ),
              ),
            );

            if (result != null) {
              print('Zadanie dodane!');
              print(
                  'Title: ${result['title']}, Pomodoro Count: ${result['pomodoroCount']}');
            }
          },
          child: const Icon(Icons.add, size: 32, color: Colors.black),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1B1B1B), Color(0xFF292929)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TodaySummary(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TaskList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
