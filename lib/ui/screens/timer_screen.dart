import 'package:flutter/material.dart';
import 'package:pomidor/data/database/app_database.dart';
import 'package:pomidor/ui/components/custom_timer_widget.dart';

//
class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key, required this.task});

  final Task task;

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late double progress;
  late String remainingTime;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: widget.task.pomodoroCount * 25 * 60),
      vsync: this,
    )..addListener(() {
        setState(() {
          progress = _controller.value;
          remainingTime = _getRemainingTime();
        });
      });

    progress = _controller.value;
    remainingTime = _getRemainingTime();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getRemainingTime() {
    final totalDuration = _controller.duration?.inSeconds ?? 0;
    final remainingSeconds = ((1 - _controller.value) * totalDuration).round();

    final minutes = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingSeconds % 60).toString().padLeft(2, '0');

    return '$minutes:$seconds';
  }

  void _startOrResumeTimer() {
    if (_controller.isDismissed) {
      _controller.forward(from: 0.0);
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTimerWidget(
            progress: progress,
            remainingTime: remainingTime,
            label: widget.task.title,
            onTap: _startOrResumeTimer,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  _controller.stop();
                },
                icon: const Icon(Icons.pause),
              ),
              IconButton(
                onPressed: () {
                  _controller.reset();
                  setState(() {
                    progress = 0.0;
                    remainingTime = _getRemainingTime();
                  });
                },
                icon: const Icon(Icons.refresh),
              ),
              IconButton(
                onPressed: _startOrResumeTimer,
                icon: const Icon(Icons.play_arrow),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
