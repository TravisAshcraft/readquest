// lib/models/book.dart
class Book {
  final String id;
  final String title;
  final String? author;
  final int pointValue;
  final int wordCount;
  final String? genre;

  Book({
    required this.id,
    required this.title,
    this.author,
    required this.pointValue,
    required this.wordCount,
    this.genre,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
    id:         json['id']        as String,
    title:      json['title']     as String,
    author:     json['author']    as String?,
    pointValue: json['point_value'] as int,
    wordCount:  json['word_count']  as int,
    genre:      json['genre']     as String?,
  );
}
