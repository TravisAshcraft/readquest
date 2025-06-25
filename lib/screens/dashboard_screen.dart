// lib/screens/dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:readquest/screens/signin_screen.dart';
import 'package:readquest/screens/quiz_screen.dart';
import 'package:readquest/screens/manage_books_screen.dart';
import '../models/user.dart';
import '../models/assigned_book.dart';
import '../services/book_service.dart';
import '../services/user_service.dart';                  // fetchUserByName
import '../theme/app_colors.dart';
import '../widgets/assigned_book_card.dart';
import '../widgets/mascot_widget.dart';
import '../widgets/user_progress_card.dart';

class DashboardScreen extends StatefulWidget {
  final String readerName;
  const DashboardScreen({Key? key, required this.readerName})
      : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<User>               _userFuture;
  late Future<List<AssignedBook>> _assignedFuture;

  @override
  void initState() {
    super.initState();
    _reloadAll();
  }

  void _reloadAll() {
    _userFuture     = fetchUserByName(widget.readerName);
    _assignedFuture = fetchAssignedBooks(widget.readerName);
  }

  void _goToQuiz(AssignedBook book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizScreen(
          readerName: widget.readerName,
          bookId:     book.bookId,
          bookTitle:  book.title,
        ),
      ),
    ).then((_) => setState(_reloadAll));
  }

  Future<void> _switchReader() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('selectedReader');
    // Pop everything and go back to SignInScreen
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const SignInScreen()),
          (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: AppColors.skyBlue),
              child: Text(
                'Hello, ${widget.readerName}!',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const ListTile(title: Text('Reading')),
            const ListTile(title: Text('Games')),
            const ListTile(title: Text('Videos')),

            ListTile(
              title: const Text('Parent View'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ManageBooksScreen(),
                  ),
                );
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.switch_account),
              title: const Text('Switch Reader'),
              onTap: () {
                Navigator.pop(context);
                _switchReader();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Great job, ${widget.readerName}! 🎉'),
        backgroundColor: AppColors.primaryPeach,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [

            // 1) Fetch user, then show progress AND mascot
            FutureBuilder<User>(
              future: _userFuture,
              builder: (ctx, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snap.hasError) {
                  return Center(child: Text('Error: ${snap.error}'));
                }
                final userData = snap.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserProgressCard(user: userData),
                    const SizedBox(height: 20),
                    MascotMotivationCard(user: userData),
                  ],
                );
              },
            ),

            const SizedBox(height: 20),

            // 2) Fetch assigned books
            FutureBuilder<List<AssignedBook>>(
              future: _assignedFuture,
              builder: (ctx, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snap.hasError) {
                  return Center(child: Text('Error: ${snap.error}'));
                }
                final books = snap.data!;
                if (books.isEmpty) {
                  return const Center(child: Text("No books assigned yet."));
                }
                final latest = books.last;
                return AssignedBookCard(
                  bookTitle: latest.title,
                  onTestPressed: () => _goToQuiz(latest),
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}
