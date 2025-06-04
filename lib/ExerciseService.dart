import 'Exercise.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ExerciseService {
  static const String apiUrl =
      'https://68252ec20f0188d7e72c394f.mockapi.io/dev/workouts';

  static Future<List<Exercise>> fetchExercises() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Exercise.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load exercises');
    }
  }
}