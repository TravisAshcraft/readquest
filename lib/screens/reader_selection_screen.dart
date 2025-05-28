// lib/screens/reader_selection_screen.dart

import 'package:flutter/material.dart';
import 'package:readquest/screens/manage_books_screen.dart';  // ← import admin page

class ReaderSelectScreen extends StatelessWidget {
  final Future<void> Function(String) onSelected;

  const ReaderSelectScreen({super.key, required this.onSelected});

  final List<String> readers = const [
    'Londyn',
    'Aubri',
    'Heidi',
    'Mindi',
    'Kinzli',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text("Who's Reading Today?"),
        backgroundColor: const Color(0xFFF3A745),
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            tooltip: 'Parent View',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ManageBooksScreen(),
                ),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: readers.map((name) {
            return GestureDetector(
              onTap: () async {
                await onSelected(name);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(2, 4)),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.account_circle, size: 48, color: Colors.orange),
                    const SizedBox(height: 12),
                    Text(
                      name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
