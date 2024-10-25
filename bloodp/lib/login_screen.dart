import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _errorMessage = '';
  bool _isLoginMode = true; // Track if the screen is in login or signup mode

  Future<void> loginUser(String username, String password) async {
    final String url = 'http://localhost:8000/api-token-auth/'; // Django URL
    final response = await http.post(
      Uri.parse(url),
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      String token = responseData['token'];
      // Save token securely and navigate to the home page
      print('Login successful. Token: $token');
      Navigator.pushNamed(context, '/home');
    } else {
      setState(() {
        _errorMessage = 'Login failed. Please try again.';
      });
    }
  }

  Future<void> signUpUser(String username, String password, String email) async {
    final String url = 'http://localhost:8000/api/signup/'; // Adjust the URL to your signup endpoint
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
        'email': email,
      }),
    );

    if (response.statusCode == 201) {
      setState(() {
        _errorMessage = 'Signup successful. Please log in.';
        _isLoginMode = true; // Switch back to login mode after successful signup
      });
    } else {
      setState(() {
        _errorMessage = 'Signup failed. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLoginMode ? 'Login' : 'Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            if (!_isLoginMode) // Show email field only in signup mode
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_isLoginMode) {
                  loginUser(_usernameController.text, _passwordController.text);
                } else {
                  signUpUser(
                    _usernameController.text,
                    _passwordController.text,
                    _emailController.text,
                  );
                }
              },
              child: Text(_isLoginMode ? 'Login' : 'Sign Up'),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                setState(() {
                  _isLoginMode = !_isLoginMode; // Toggle between login and signup
                  _errorMessage = ''; // Clear error message on mode switch
                });
              },
              child: Text(_isLoginMode ? 'Create an account' : 'Have an account? Login'),
            ),
            if (_errorMessage.isNotEmpty) ...[
              SizedBox(height: 20),
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
