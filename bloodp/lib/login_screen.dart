import 'package:flutter/material.dart';
import 'signup_screen.dart';
import '../api_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ApiService apiService = ApiService();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  String? token;

  void _login() async {
    final token = await apiService.authenticate(
      usernameController.text,
      passwordController.text,
    );

    if (token != null) {
      setState(() {
        this.token = token; // Store the token for display or use later
      });
      // Navigate to the home page or display the readings
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage())); // Uncomment and define HomePage if needed
    } else {
      // Handle error (e.g., show a snackbar)
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
            // Display connection status
            if (token != null)
              Text("Connected! Token: $token")
            else
              Text("Not connected."),
          ],
        ),
      ),
    );
  }
}
