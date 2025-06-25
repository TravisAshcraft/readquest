import 'package:flutter/material.dart';
import 'package:readquest/screens/reader_selection_screen.dart';
import 'package:readquest/screens/signup_screen.dart';
import 'package:readquest/screens/terms_screen.dart';
import 'package:readquest/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:readquest/screens/manage_books_screen.dart';
import 'package:readquest/screens/signin_screen.dart'; // <-- new screen
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
      routes: {
        '/manage-books': (_) => const ManageBooksScreen(),
        '/signin': (_) => const SignInScreen(), // <-- new route
        '/signup': (_) => const SignUpScreen(),
        '/terms': (context) => const TermsScreen(),
      },
      home: const SignInScreen(), // <-- new home screen
    );
  }
}
