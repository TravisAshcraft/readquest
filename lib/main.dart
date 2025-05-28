import 'package:flutter/material.dart';
import 'package:readquest/screens/reader_selection_screen.dart';
import 'package:readquest/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:readquest/screens/manage_books_screen.dart';
import 'models/user.dart';
import 'theme/app_colors.dart';
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
        // register the admin page under a named route
      routes: {
        '/manage-books': (_) => const ManageBooksScreen(),
          },
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
  User? user;

  @override
  void initState() {
    super.initState();
    _loadReader();
  }

  Future<void> _loadReader() async {
    final prefs = await SharedPreferences.getInstance();
    final savedReader = prefs.getString('selectedReader');

    if (savedReader != null) {
      // fetch the user before setState
      try {
        final fetchedUser = await fetchUserByName(savedReader);
        setState(() {
          reader = savedReader;
          user   = fetchedUser;
        });
      } catch (e) {
        // handle errors (e.g. clear prefs and show selection again)
        await prefs.remove('selectedReader');
        setState(() {
          reader = null;
          user   = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (reader == null) {
      // Show reader selection screen
      return ReaderSelectScreen(onSelected: (name) async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('selectedReader', name);

        reader = name;
        user = await fetchUserByName(name);
        setState(() {});
      });
    }
    // Reader selected but user data not yet loaded
    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Both reader and user are ready
    return DashboardScreen(readerName: user!.name);
  }


}
