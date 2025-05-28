import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

Future<User> fetchUserByName(String name) async {
  final response = await http.get(Uri.parse('http://98.22.140.98:8080/get-user-progress?name=$name'));


  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return User.fromJson(data);
  } else {
    throw Exception('Failed to load user');
  }
}
