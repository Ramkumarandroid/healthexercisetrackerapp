import 'Exercise.dart';
import 'ExerciseService.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ExerciseEvent {}

class LoadExercises extends ExerciseEvent {}

class CompleteExercise extends ExerciseEvent {
  final String id;

  CompleteExercise(this.id);
}

abstract class ExerciseState {}

class ExerciseInitial extends ExerciseState {}

class ExerciseLoading extends ExerciseState {}

class ExerciseLoaded extends ExerciseState {
  final List<Exercise> exercises;

  ExerciseLoaded(this.exercises);
}

class ExerciseError extends ExerciseState {
  final String message;

  ExerciseError(this.message);
}

class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  ExerciseBloc() : super(ExerciseInitial()) {
    on<LoadExercises>((event, emit) async {
      emit(ExerciseLoading());
      try {
        final exercises = await ExerciseService.fetchExercises();
        emit(ExerciseLoaded(exercises));
      } catch (e) {
        emit(ExerciseError(e.toString()));
      }
    });
    on<CompleteExercise>((event, emit) {
      if (state is ExerciseLoaded) {
        final currentState = state as ExerciseLoaded;
        final updatedExercises =
            currentState.exercises.map((e) {
              if (e.id == event.id) {
                return Exercise(
                  id: e.id,
                  name: e.name,
                  description: e.description,
                  duration: e.duration,
                  difficulty: e.difficulty,
                  completed: true,
                );
              }
              return e;
            }).toList();

        emit(ExerciseLoaded(updatedExercises));
      }
    });
  }
}
