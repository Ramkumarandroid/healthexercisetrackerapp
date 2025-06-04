import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'ExerciseBloc.dart';
import 'ExerciseDetailScreen.dart';
import 'StreakBloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exercise App',
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ExerciseBloc()..add(LoadExercises())),
          BlocProvider(create: (_) => StreakBloc()..add(LoadStreakEvent())),
        ],
        child: const HomeScreen(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🏋️ HealthExercise Tracker APP')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔥 Streak Section
          BlocBuilder<StreakBloc, StreakState>(
            builder: (context, state) {
              if (state is StreakLoaded) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '🔥 Current Streak: ${state.streak} day(s)',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                );
              }
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Loading streak...',
                  style: TextStyle(fontSize: 16),
                ),
              );
            },
          ),

          // 📋 Exercise List Section
          Expanded(
            child: BlocBuilder<ExerciseBloc, ExerciseState>(
              builder: (context, state) {
                if (state is ExerciseLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ExerciseError) {
                  return Center(child: Text(state.message));
                } else if (state is ExerciseLoaded) {
                  return ListView.builder(
                    itemCount: state.exercises.length,
                    itemBuilder: (context, index) {
                      final exercise = state.exercises[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          title: Text(exercise.name),
                          subtitle: Text(
                            '${exercise.duration}s • ${exercise.difficulty}',
                          ),
                          trailing:
                              exercise.completed
                                  ? const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  )
                                  : const Icon(
                                    Icons.fitness_center,
                                    color: Colors.grey,
                                  ),
                          onTap: () async {
                            final completedId = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => ExerciseDetailScreen(
                                      exercise: exercise,
                                    ),
                              ),
                            );

                            if (completedId != null) {
                              context.read<ExerciseBloc>().add(
                                CompleteExercise(completedId),
                              );
                            }
                          },
                        ),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

