// lib/models/child.dart

/// A single child account in ReadQuest.
class Child {
  /// Unique identifier for this child (UUID or similar).
  final String id;

  /// Display name of the child.
  final String name;

  /// Total number of books the child has read.
  final int booksRead;

  /// Current point balance for this child.
  final int points;

  /// Current pairing code (6-digit rotating or TOTP) used for device linking.
  final String pairingCode;

  const Child({
    required this.id,
    required this.name,
    this.booksRead = 0,
    this.points = 0,
    required this.pairingCode,
  });

  /// Creates a [Child] from JSON. Supports either camelCase or snake_case keys.
  factory Child.fromJson(Map<String, dynamic> json) {
    int _parseInt(dynamic v) => v is int ? v : int.tryParse(v?.toString() ?? '') ?? 0;

    return Child(
      id: json['id'] as String,
      name: json['name'] as String,
      booksRead: _parseInt(json['booksRead'] ?? json['books_read']),
      points: _parseInt(json['points']),
      pairingCode: (json['pairingCode'] ?? json['pairing_code']) as String,
    );
  }

  /// Exports this [Child] to a JSON map in camelCase.
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'booksRead': booksRead,
    'points': points,
    'pairingCode': pairingCode,
  };

  /// Creates a copy of this child, overriding any fields you need.
  Child copyWith({
    String? id,
    String? name,
    int? booksRead,
    int? points,
    String? pairingCode,
  }) {
    return Child(
      id: id ?? this.id,
      name: name ?? this.name,
      booksRead: booksRead ?? this.booksRead,
      points: points ?? this.points,
      pairingCode: pairingCode ?? this.pairingCode,
    );
  }

  @override
  String toString() {
    return 'Child(id: $id, name: $name, booksRead: $booksRead, '
        'points: $points, pairingCode: $pairingCode)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Child &&
        other.id == id &&
        other.name == name &&
        other.booksRead == booksRead &&
        other.points == points &&
        other.pairingCode == pairingCode;
  }

  @override
  int get hashCode => Object.hash(id, name, booksRead, points, pairingCode);
}