import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';



abstract class StreakEvent {}

class LoadStreakEvent extends StreakEvent {}

class UpdateStreakEvent extends StreakEvent {}

abstract class StreakState {}

class StreakInitial extends StreakState {}

class StreakLoaded extends StreakState {
  final int streak;
  StreakLoaded(this.streak);
}

class StreakBloc extends Bloc<StreakEvent, StreakState> {
  StreakBloc() : super(StreakInitial()) {
    on<LoadStreakEvent>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      final streak = prefs.getInt('streak_count') ?? 0;
      emit(StreakLoaded(streak));
    });

    on<UpdateStreakEvent>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now();
      print("DateTime : $now");
      final today = DateTime(now.year, now.month, now.day);
      print("DateTimetoday : $today");
      final lastDateStr = prefs.getString('last_completed_date');
      int streak = prefs.getInt('streak_count') ?? 0;
      print("StreakCount:$streak");
      if (lastDateStr != null) {
        final lastDate = DateTime.parse(lastDateStr);
        final diff = today.difference(lastDate).inDays;

        if (diff == 1) {
          streak += 1;
        } else if (diff > 1) {
          streak = 1;
        }
      } else {
        streak = 1;
      }

      await prefs.setString('last_completed_date', today.toIso8601String());
      await prefs.setInt('streak_count', streak);

      emit(StreakLoaded(streak));
    });
  }
}
