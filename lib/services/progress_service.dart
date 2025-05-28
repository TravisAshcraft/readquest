import 'dart:convert';

import 'package:http/http.dart' as http;

/// Marks a book completed on the backend.
Future<void> completeBook({
  required String readerName,
  required String bookId,
  required int score,
}) async {
  final uri = Uri.parse(
      'http://98.22.140.98:8080/complete-book'
          '?name=${Uri.encodeComponent(readerName)}'
          '&book_id=${Uri.encodeComponent(bookId)}'
          '&score=$score'
  );
  final resp = await http.post(uri);
  if (resp.statusCode != 200) {
    throw Exception('Failed to complete book: ${resp.statusCode} ${resp.body}');
  }
}

/// Sends the quiz results to your FastAPI `/submit-progress`
/// so the backend can update points, XP, books_read, etc.
Future<void> submitProgress({
  required String readerName,
  required String completedTopic,
  required int pointsEarned,
  int newXp = 0,
}) async {
  final uri = Uri.parse('http://98.22.140.98:8080/submit-progress');
  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'reader_name':     readerName,
      'completed_topic': completedTopic,
      'points_earned':   pointsEarned,
      'new_xp':          newXp,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception(
        'submitProgress failed (${response.statusCode}): ${response.body}'
    );
  }
}
