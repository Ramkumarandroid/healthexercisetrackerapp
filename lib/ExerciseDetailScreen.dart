import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'Exercise.dart';
import 'ExerciseBloc.dart';
import 'StreakBloc.dart';


class ExerciseDetailScreen extends StatefulWidget {
  final Exercise exercise;
  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  int remaining = 0;
  Timer? _timer;
  bool isStarted = false;

  void startExercise() {
    setState(() {
      remaining = widget.exercise.duration;
      isStarted = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => remaining--);
      if (remaining <= 0) {
        timer.cancel();
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Done!'),
            content: const Text('Exercise Completed.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.pop(context, widget.exercise.id);// Pass ID back to previous screen
                 /* final currentState = context.read<StreakBloc>().state;
                  if (currentState is StreakLoaded) {
                    context.read<StreakBloc>().add(UpdateStreakEvent());
                  }*/
                },
                //onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                child: const Text('OK'),
              )
            ],
          ),
        );
        context.read<ExerciseBloc>().add(CompleteExercise(widget.exercise.id));
        context.read<StreakBloc>().add(UpdateStreakEvent());

      }
    });
  }

  void completeExercise() {
    setState(() {
      isStarted = false;
      remaining = 0;
      widget.exercise.completed = true; // ✅ Mark as completed
    });
    context.read<ExerciseBloc>().add(CompleteExercise(widget.exercise.id));
    //Navigator.pop(context);
    Navigator.pop(context, widget.exercise.id); // Return updated exercise
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.exercise;
    return Scaffold(
      appBar: AppBar(title: Text(e.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card containing exercise details
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Description: ${e.description}',
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('Duration: ${e.duration} seconds',
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('Difficulty: ${e.difficulty}',
                        style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            if (isStarted)
              Text('Remaining: $remaining s', style: const TextStyle(fontSize: 24)),

            const SizedBox(height: 20),

            if (!isStarted)
              ElevatedButton(onPressed: startExercise, child: const Text('Start')),
          ],
        ),
      ),
    );
  }
}