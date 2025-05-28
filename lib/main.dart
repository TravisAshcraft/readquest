import 'package:flutter/material.dart';
import 'package:readquest/screens/reader_selection_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme/app_colors.dart';
import 'screens/reader_selection_screen.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(const ReadQuestApp());
}

class ReadQuestApp extends StatelessWidget {
  const ReadQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReadQuest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryPeach,
        scaffoldBackgroundColor: AppColors.softBlue,
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Roboto', fontSize: 16),
        ),
      ),
      home: const ReaderLoader(),
    );
  }
}

class ReaderLoader extends StatefulWidget {
  const ReaderLoader({super.key});

  @override
  State<ReaderLoader> createState() => _ReaderLoaderState();
}

class _ReaderLoaderState extends State<ReaderLoader> {
  String? reader;

  @override
  void initState() {
    super.initState();
    _loadReader();
  }

  Future<void> _loadReader() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      reader = prefs.getString('selectedReader');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (reader == null) {
      return ReaderSelectScreen(onSelected: (name) async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('selectedReader', name);
        setState(() => reader = name);
      });
    } else {
      return DashboardScreen(readerName: reader!);
    }
  }
}
