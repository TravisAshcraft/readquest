// lib/services/quiz_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quiz_question.dart';

/// Fetches the quiz JSON from your FastAPI `/book-quiz` endpoint
/// and returns a typed List<QuizQuestion>.
Future<List<QuizQuestion>> fetchQuiz(String bookTitle) async {
  final uri = Uri.parse(
      'http://98.22.140.98:8080/book-quiz?title=${Uri.encodeComponent(bookTitle)}'
  );

  final response = await http.get(uri);
  if (response.statusCode != 200) {
    throw Exception('Failed to load quiz: ${response.statusCode}');
  }

  final decoded = json.decode(response.body);

  // The backend can return either:
  // 1) a bare List of question objects, or
  // 2) an object with a 'quiz_json' field containing the list
  List<dynamic>? quizList;
  if (decoded is List) {
    quizList = decoded;
  } else if (decoded is Map<String, dynamic> && decoded.containsKey('quiz_json')) {
    quizList = decoded['quiz_json'] as List<dynamic>;
  }

  if (quizList == null) {
    throw Exception('Unexpected quiz format');
  }
  if (quizList.isEmpty) {
    return []; // no questions
  }

  // Map each item into your QuizQuestion model
  return quizList
      .map((q) => QuizQuestion.fromJson(q as Map<String, dynamic>))
      .toList();
}
