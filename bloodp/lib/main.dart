import 'package:flutter/material.dart';
import 'login_screen.dart';   // Import your login screen
import 'signup_screen.dart';  // Import your signup screen
import 'dashboard_page.dart';  // Import your dashboard page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blood Pressure Management System',
      debugShowCheckedModeBanner: false, // Hides the debug banner
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          elevation: 0,
        ),
      ),
      initialRoute: '/login',  // Set the initial route to login
      routes: {
        '/login': (context) => LoginPage(),     // Login page
        '/signup': (context) => SignupPage(),   // Signup page
        '/dashboard': (context) => const DashboardPage(), // Dashboard page
      },
    );
  }
}
