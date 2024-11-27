import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'dashboard_page.dart'; // Patient Dashboard Page
import 'patient_list_page.dart'; // Doctor's Patients List Page
import '../api_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ApiService apiService = ApiService();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void _login() async {
  final token = await apiService.authenticate(
    usernameController.text,
    passwordController.text,
  );

  if (token != null) {
    // Fetch the user role
    final userRole = await apiService.getUserRole();

    if (userRole == 'doctor') {
      // Navigate to the Patients List Page for doctors
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PatientListPage(token)),
      );
    } else if (userRole == 'patient') {
      // Navigate to the Dashboard Page for patients
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage()),
      );
    } else {
      // Handle unknown role (optional)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unknown role')),
      );
    }
  } else {
    // Handle login failure
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Login failed')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            TextButton(
              child: Text('Don\'t have an account? Sign up'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
