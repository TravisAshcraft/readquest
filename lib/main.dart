// lib/main.dart
import 'package:flutter/material.dart';
import 'package:readquest/screens/roleselection_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/reader_selection_screen.dart';
import 'screens/signin_screen.dart';
import 'screens/childsignin_screen.dart';
import 'screens/parentdashboard_screen.dart';
import 'screens/childhome_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/terms_screen.dart';
import 'screens/manage_books_screen.dart';
import 'theme/app_colors.dart';

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
      ),
      routes: {
        '/role-selection': (_) => const RoleSelectionScreen(),
        '/signin':    (_) => const SignInScreen(),
        '/childsignin':     (_) => const ChildSignInScreen(),
        '/signup':           (_) => const SignUpScreen(),
        '/terms':            (_) => const TermsScreen(),
        '/manage-books':     (_) => const ManageBooksScreen(),
      },
      home: const SplashScreen(),
    );
  }
}