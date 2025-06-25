import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms & Conditions')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            '''
Welcome to ReadQuest!

Effective Date: June 24, 2025

These Terms and Conditions ("Terms") govern your use of the ReadQuest mobile application ("App") and related services provided by Half Byte Games ("Company", "we", "us", or "our").

By accessing or using the App, you agree to comply with and be bound by these Terms. If you do not agree with any part of these Terms, you must not use the App.

1. Eligibility and Registration
You must be at least 18 years old to create a parent account. Children may only use the App through a parent-managed account. You agree to provide accurate, current, and complete information during registration and to keep it updated.

2. Account Responsibility
You are responsible for safeguarding your login credentials and any activity under your account. You must notify us immediately of any unauthorized use of your account.

3. Data Collection and Privacy
We collect personal information such as name, email, date of birth, phone number, ZIP code, and app usage details. This data is used to improve your experience and will not be sold or shared without consent except where required by law. See our Privacy Policy for more details.

4. Acceptable Use
You agree not to:
- Violate any laws or regulations;
- Post or share harmful, offensive, or illegal content;
- Attempt to hack, disrupt, or otherwise interfere with the App;
- Impersonate another user or gain unauthorized access.

5. Intellectual Property
All content, trademarks, and code are the property of Half Byte Games or its licensors. You may not reproduce, distribute, or create derivative works without explicit permission.

6. User-Generated Content
If you submit feedback or content, you grant us a non-exclusive, royalty-free license to use, reproduce, modify, and distribute it in any format and media.

7. Termination
We may suspend or terminate your access to the App without notice for violations of these Terms. Upon termination, all rights granted to you will cease immediately.

8. Updates to Terms
These Terms may be updated at any time. Your continued use of the App constitutes acceptance of any updates.

9. No Warranty
The App is provided “as-is” without warranties of any kind, either express or implied. We do not guarantee that the App will be error-free or uninterrupted.

10. Limitation of Liability
To the fullest extent allowed by law, we are not liable for any indirect, incidental, special, consequential, or punitive damages arising from your use of the App.

11. Indemnification
You agree to indemnify and hold harmless Half Byte Games and its affiliates from any claims, liabilities, or expenses arising from your use of the App or violation of these Terms.

12. Governing Law
These Terms are governed by the laws of the State of Texas, USA. You agree to submit to the personal jurisdiction of the courts located in Texas.

13. Contact Information
For any questions, please contact us at: support@halfbytegames.net

By using the App, you confirm you have read, understood, and agreed to these Terms.
            ''',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}