class AssignedBook {
  final String bookId;
  final String title;
  final String author;
  final int pointsAwarded;
  final int wordsCounted;

  AssignedBook({
    required this.bookId,
    required this.title,
    required this.author,
    required this.pointsAwarded,
    required this.wordsCounted,
  });

  factory AssignedBook.fromJson(Map<String, dynamic> json) {
    return AssignedBook(
      bookId:        json['bookId'] as String,
      title:         json['title'] as String,
      author:        (json['author'] ?? '') as String,
      pointsAwarded: json['pointsAwarded'] as int,
      wordsCounted:  json['wordsCounted'] as int,
    );
  }
}
