import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isPatient = false;
  bool _isDoctor = false;
  String _errorMessage = '';
  bool _isLoading = false;

  Future<void> signupUser(String username, String password, bool isPatient, bool isDoctor) async {
    final String url = 'http://your_ip_address:8000/pressure/users/register/'; // Update with your backend URL

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'username': username,
          'password': password,
          'is_patient': isPatient,
          'is_doctor': isDoctor,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 201) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Signup successful!';
        });
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushNamed(context, '/login');
        });
      } else {
        setState(() {
          _isLoading = false;
          // Try to extract a more user-friendly error message
          final Map<String, dynamic> responseData = json.decode(response.body);
          _errorMessage = responseData['detail'] ?? 'Signup failed: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Signup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _isPatient,
                      onChanged: (value) {
                        setState(() {
                          _isPatient = value ?? false;
                          if (_isPatient) _isDoctor = false; // Ensure only one is selected
                        });
                      },
                    ),
                    Text('Patient'),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _isDoctor,
                      onChanged: (value) {
                        setState(() {
                          _isDoctor = value ?? false;
                          if (_isDoctor) _isPatient = false; // Ensure only one is selected
                        });
                      },
                    ),
                    Text('Doctor'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : () {
                if (_usernameController.text.isEmpty || _passwordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
                  setState(() {
                    _errorMessage = 'Please fill in all fields.';
                  });
                } else if (_passwordController.text != _confirmPasswordController.text) {
                  setState(() {
                    _errorMessage = 'Passwords do not match.';
                  });
                } else if (!_isPatient && !_isDoctor) {
                  setState(() {
                    _errorMessage = 'Please select either Patient or Doctor.';
                  });
                } else {
                  signupUser(_usernameController.text, _passwordController.text, _isPatient, _isDoctor);
                }
              },
              child: Text(_isLoading ? 'Signing Up...' : 'Signup'),
            ),
            if (_isLoading) ...[
              SizedBox(height: 20),
              CircularProgressIndicator(),
            ],
            if (_errorMessage.isNotEmpty) ...[
              SizedBox(height: 20),
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
