class User {
  final String id;
  final String name;
  final int xp;
  final int level;
  final int weeklyPoints;
  final int totalPoints;
  final int booksRead;
  final int wordsRead;
  final int readingStreak;
  final String avatar;

  User({
    required this.id,
    required this.name,
    required this.xp,
    required this.level,
    required this.weeklyPoints,
    required this.totalPoints,
    required this.booksRead,
    required this.wordsRead,
    required this.readingStreak,
    required this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '', // ID missing from response — safe fallback
      name: json['name'] ?? '',
      xp: json['xp'] ?? 0,
      level: json['level'] ?? 0,
      weeklyPoints: json['weekly_points'] ?? 0,
      totalPoints: json['total_points'] ?? 0,
      booksRead: json['books_read'] ?? 0,
      wordsRead: json['words_read'] ?? 0,
      readingStreak: json['reading_streak'] ?? 0,
      avatar: json['avatar'] ?? '', // fallback to empty string if null
    );
  }
}
