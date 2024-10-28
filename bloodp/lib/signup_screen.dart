import 'package:flutter/material.dart';
import '../api_service.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final ApiService apiService = ApiService();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isDoctor = false;

  void _signup() async {
    // Prepare the request data
    final username = usernameController.text;
    final password = passwordController.text;

    // Send the signup request
    final success = await apiService.signup(
      username,
      password,
      !isDoctor, // If isDoctor is true, then the user is not a patient
      isDoctor,
    );

    if (success) {
      // Navigate back to login or show a success message
      Navigator.pop(context);
    } else {
      // Handle error (e.g., show a snackbar)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signup failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            DropdownButton<bool>(
              value: isDoctor,
              items: [
                DropdownMenuItem(child: Text("Patient"), value: false),
                DropdownMenuItem(child: Text("Doctor"), value: true),
              ],
              onChanged: (value) {
                setState(() {
                  isDoctor = value!;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signup,
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
