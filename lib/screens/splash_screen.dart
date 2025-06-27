// lib/screens/splash_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:readquest/screens/roleselection_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'parentdashboard_screen.dart';
import 'childhome_screen.dart';
import '../models/parent.dart';
import '../models/child.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final prefs = await SharedPreferences.getInstance();

    // 1️⃣ Try parent token
    final parentToken = prefs.getString('token');
    if (parentToken != null) {
      final ok = await _tryParentLogin(parentToken);
      if (ok) return;
      await prefs.remove('token');
    }

    // 2️⃣ Try child token
    final childToken = prefs.getString('child_token');
    if (childToken != null) {
      final ok = await _tryChildLogin(childToken);
      if (ok) return;
      await prefs.remove('child_token');
    }

    // 3️⃣ Fallback → role selection
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
    );
  }

  Future<bool> _tryParentLogin(String jwt) async {
    final resp = await http.get(
      Uri.parse('https://readquest.halfbytegames.net/auth/me'),
      headers: {'Authorization': 'Bearer $jwt'},
    );
    if (resp.statusCode == 200) {
      final data = json.decode(resp.body);
      final parent = Parent.fromJson(data);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ParentDashboardScreen(
            parentName: parent.name,
            children: parent.children,
          ),
        ),
      );
      return true;
    }
    return false;
  }

  Future<bool> _tryChildLogin(String jwt) async {
    final resp = await http.get(
      Uri.parse('https://readquest.halfbytegames.net/auth/child/me'),
      headers: {'Authorization': 'Bearer $jwt'},
    );
    if (resp.statusCode == 200) {
      final data = json.decode(resp.body);
      final child = Child.fromJson(data);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ChildHomeScreen(),
        ),
      );
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext _) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}