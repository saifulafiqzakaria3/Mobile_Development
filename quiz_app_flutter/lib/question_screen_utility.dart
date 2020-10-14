import 'package:flutter/material.dart';

import 'question.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

Future<List<Question>> fetchQuestions(String url) async {
  List<Question> questions;
  final response = await http.get(url);

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    var results = data['results'] as List;
    questions =
        results.map<Question>((json) => Question.fromJson(json)).toList();
    return questions; //Question.fromJson(jsonDecode(response.body));
  } else {
    // Throw an exception if error.
    throw Exception('Failed to load Question');
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
