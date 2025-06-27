// lib/models/parent.dart

import 'child.dart';

class Parent {
  final String id;
  final String name;
  final String email;
  final List<Child> children;

  Parent({
    required this.id,
    required this.name,
    required this.email,
    required this.children,
  });

  factory Parent.fromJson(Map<String, dynamic> json) {
    return Parent(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      children: (json['children'] as List)
          .map((c) => Child.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }
}