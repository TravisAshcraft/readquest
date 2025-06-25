import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String _fullName = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _phone = '';
  String _zip = '';
  String _dob = '';
  bool _isLoading = false;
  String? _errorMessage;
  bool _agreedToTerms = false;

  Future<void> _signUp() async {
    if (!_agreedToTerms) {
      setState(() => _errorMessage = 'You must agree to the terms to continue.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('https://readquest.halfbytegames.net/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'full_name': _fullName.trim(),
          'email': _email.trim(),
          'password': _password,
          'phone': _phone.trim(),
          'zip_code': _zip.trim(),
          'dob': _dob,
        }),
      );

      if (response.statusCode == 201) {
        Navigator.pushReplacementNamed(context, '/signin');
      } else {
        final data = jsonDecode(response.body);
        setState(() {
          _errorMessage = data['detail'] ?? 'Sign up failed. Try again.';
        });
      }
    } catch (_) {
      setState(() {
        _errorMessage = 'Network error. Please try again.';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Create Account'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFB5FFC), Color(0xFFE3F2FD)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Create Your Account',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Parent Registration',
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 20),
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    TextFormField(
                      decoration: _inputDecoration('Full Name', Icons.person),
                      onChanged: (val) => _fullName = val,
                      validator: (val) =>
                      val == null || val.trim().isEmpty ? 'Enter full name' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: _inputDecoration('Email', Icons.email),
                      onChanged: (val) => _email = val,
                      validator: (val) =>
                      val == null || !val.contains('@') ? 'Enter valid email' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      obscureText: true,
                      decoration: _inputDecoration('Password', Icons.lock),
                      onChanged: (val) => _password = val,
                      validator: (val) =>
                      val == null || val.length < 6 ? 'Min 6 characters' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      obscureText: true,
                      decoration: _inputDecoration('Confirm Password', Icons.lock_outline),
                      onChanged: (val) => _confirmPassword = val,
                      validator: (val) =>
                      val != _password ? 'Passwords do not match' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: _inputDecoration('Phone Number', Icons.phone),
                      keyboardType: TextInputType.phone,
                      onChanged: (val) => _phone = val,
                      validator: (val) =>
                      val == null || val.length < 10 ? 'Enter valid phone number' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: _inputDecoration('ZIP Code', Icons.location_on),
                      keyboardType: TextInputType.number,
                      onChanged: (val) => _zip = val,
                      validator: (val) =>
                      val == null || val.length < 5 ? 'Enter ZIP code' : null,
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime(1980),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _dob = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                          });
                        }
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: _inputDecoration('Date of Birth', Icons.cake).copyWith(
                            hintText: _dob.isEmpty ? 'Select your date of birth' : _dob,
                          ),
                          validator: (_) => _dob.isEmpty ? 'Please select your date of birth' : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Checkbox(
                          value: _agreedToTerms,
                          onChanged: (val) {
                            setState(() => _agreedToTerms = val ?? false);
                          },
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/terms');
                            },
                            child: const Text.rich(
                              TextSpan(
                                text: 'I agree to the ',
                                children: [
                                  TextSpan(
                                    text: 'terms and conditions',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _signUp();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFB5FFC),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}