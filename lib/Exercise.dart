import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

// MODEL
class Exercise {
  final String id;
  final String name;
  final String description;
  final int duration;
  final String difficulty;
  bool completed;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.duration,
    required this.difficulty,
    this.completed = false,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      duration: int.parse(json['duration'].toString()),
      difficulty: json['difficulty'],
    );
  }
}
