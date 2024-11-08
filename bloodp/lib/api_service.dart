import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ApiService {
  final String baseUrl = 'http://192.168.131.74'; // Replace with your actual base URL

  /// Sign up a new user
  Future<bool> signup(String username, String password, bool isPatient, bool isDoctor) async {
    final requestData = {
      "username": username,
      "password": password,
      "is_patient": isPatient,
      "is_doctor": isDoctor,
    };

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/pressure/users/register/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 201) { // 201 Created
        return true; // Sign-up successful
      } else {
        print('Signup failed: ${response.body}'); // Print error for debugging
        return false; // Sign-up failed
      }
    } catch (e) {
      print('Error during signup: $e'); // Print error for debugging
      return false; // Handle exceptions
    }
  }

  /// Authenticate user and retrieve token
  Future<String?> authenticate(String username, String password) async {
    final requestData = {
      "username": username,
      "password": password,
    };

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api-token-auth/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Access the token using the correct key
        if (data['token'] != null) {
          // Save the token using shared_preferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', data['token']); // Updated key
          return data['token']; // Return the token
        } else {
          print('No token found in response: ${response.body}');
          return null; // Handle case where token is missing
        }
      } else {
        print('Login failed: ${response.body}'); // Print error for debugging
        return null; // Authentication failed
      }
    } catch (e) {
      print('Error during login: $e'); // Print error for debugging
      return null; // Handle exceptions
    }
  }

  /// Get the stored authentication token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token'); // Retrieve token
  }

  /// Logout user by removing the token from shared_preferences
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Remove the token
  }
}
