// lib/screens/childhome_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/child.dart';

class ChildHomeScreen extends StatefulWidget {
  const ChildHomeScreen({Key? key}) : super(key: key);

  @override
  State<ChildHomeScreen> createState() => _ChildHomeScreenState();
}

class _ChildHomeScreenState extends State<ChildHomeScreen> {
  Child? _child;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadChildProfile();
  }

  Future<void> _loadChildProfile() async {
    setState(() { _loading = true; _error = null; });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('child_token');
    if (token == null) {
      setState(() {
        _error = 'Not signed in';
        _loading = false;
      });
      return;
    }

    try {
      final resp = await http.get(
        Uri.parse('https://readquest.halfbytegames.net/auth/child/me'),
        headers: { 'Authorization': 'Bearer $token' },
      );
      if (resp.statusCode == 200) {
        final data = json.decode(resp.body);
        setState(() {
          _child = Child.fromJson(data);
          _loading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to fetch profile';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_child != null ? 'Welcome, ${_child!.name}' : 'Welcome'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadChildProfile,
          )
        ],
      ),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : _error != null
            ? Text(_error!,
            style: const TextStyle(color: Colors.red))
            : Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _child!.name,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              Text('Books Read: ${_child!.booksRead}',
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text('Points: ${_child!.points}',
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Sign Out'),
                onPressed: () async {
                  final prefs =
                  await SharedPreferences.getInstance();
                  await prefs.remove('child_token');
                  Navigator.pushReplacementNamed(
                      context, '/reader-selection');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}