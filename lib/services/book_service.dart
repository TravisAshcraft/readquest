import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/assigned_book.dart';
import '../models/book.dart';

const _baseUrl = 'http://98.22.140.98:8080';

Future<List<AssignedBook>> fetchAssignedBooks(String readerName) async {
  final uri = Uri.parse('http://98.22.140.98:8080/assigned-books')
      .replace(queryParameters: {'name': readerName});
  final resp = await http.get(uri);

  if (resp.statusCode == 200) {
    final List<dynamic> data = json.decode(resp.body);
    return data.map((e) => AssignedBook.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load assigned books: ${resp.body}');
  }
}

Future<List<Book>> fetchBooks() async {
  final resp = await http.get(Uri.parse('$_baseUrl/books'));
  if (resp.statusCode != 200) {
    throw Exception('Failed to load books');
  }
  final data = json.decode(resp.body) as List<dynamic>;
  return data.map((j) => Book.fromJson(j as Map<String, dynamic>)).toList();
}

Future<void> addBook({
  required String title,
  String? author,
  required int pointValue,
  required int wordCount,
  String? genre,
}) async {
  final uri = Uri.parse('$_baseUrl/add-book');
  final body = jsonEncode({
    'title':       title,
    'author':      author,
    'point_value': pointValue,
    'word_count':  wordCount,
    'genre':       genre,
  });
  final resp = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: body,
  );
  if (resp.statusCode != 200) {
    throw Exception('Add book failed: ${resp.body}');
  }
}

Future<void> assignBook({
  required String readerName,
  required String bookTitle,
}) async {
  final uri = Uri.parse('$_baseUrl/assign-book');
  final body = jsonEncode({
    'reader_name': readerName,
    'book_title':  bookTitle,
  });
  final resp = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: body,
  );
  if (resp.statusCode != 200) {
    throw Exception('Assign book failed: ${resp.body}');
  }
}