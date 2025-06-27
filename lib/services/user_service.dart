// lib/services/user_service.dart

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/child.dart';
import '../models/parent.dart';

class UserService {
  static const _baseUrl = 'https://readquest.halfbytegames.net';

  /// Sign-in and persist the JWT
  Future<void> signIn(String email, String password) async {
    final resp = await http.post(
      Uri.parse('$_baseUrl/auth/signin'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (resp.statusCode != 200) {
      final err = jsonDecode(resp.body);
      throw Exception(err['detail'] ?? 'Sign in failed');
    }
    final data = jsonDecode(resp.body);
    final token = data['access_token'];
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt', token);
  }

  /// Read the saved JWT
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt');
  }

  /// GET /auth/me
  Future<Parent> fetchProfile() async {
    final jwt = await _getToken();
    if (jwt == null) throw Exception('Not logged in');
    final resp = await http.get(
      Uri.parse('$_baseUrl/auth/me'),
      headers: {'Authorization': 'Bearer $jwt'},
    );
    if (resp.statusCode != 200) {
      throw Exception('Failed to load profile');
    }
    final jsonMap = jsonDecode(resp.body) as Map<String, dynamic>;
    return Parent.fromJson(jsonMap);
  }

  /// POST /children
  Future<Child> createChild(String name) async {
    final jwt = await _getToken();
    if (jwt == null) throw Exception('Not logged in');
    final resp = await http.post(
      Uri.parse('$_baseUrl/children'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwt',
      },
      body: jsonEncode({'name': name}),
    );
    if (resp.statusCode != 201) {
      final err = jsonDecode(resp.body);
      throw Exception(err['detail'] ?? 'Failed to create child');
    }
    final jsonMap = jsonDecode(resp.body) as Map<String, dynamic>;
    return Child.fromJson(jsonMap);
  }
}