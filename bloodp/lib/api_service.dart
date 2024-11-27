import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ApiService {
  final String baseUrl = 'https://41dc-41-89-99-5.ngrok-free.app'; // Replace with your actual base URL

  /// Helper to debug responses
  void _debugResponse(String operation, http.Response response) {
    print('--- $operation ---');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
  }

  /// Helper to debug exceptions
  void _debugException(String operation, dynamic e) {
    print('Error during $operation: $e');
  }

  /// Sign up a new user
  Future<bool> signup(String username, String password, bool isPatient, bool isDoctor) async {
    final requestData = {
      "username": username,
      "password": password,
      "is_doctor": isDoctor,
      "is_patient": isPatient,

    };

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/pressure/users/register/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );

      _debugResponse('Signup', response);

      return response.statusCode == 201; // Return true if signup is successful
    } catch (e) {
      _debugException('signup', e);
      return false;
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

      _debugResponse('Authentication', response);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];

        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          if (data['user'] != null) {
            await prefs.setString('username', data['user']['username']);
          }
          return token;
        } else {
          print('No token in response.');
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      _debugException('authenticate', e);
      return null;
    }
  }

  /// Get the stored authentication token
  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      print('Fetched token: $token');
      return token;
    } catch (e) {
      _debugException('getToken', e);
      return null;
    }
  }

  /// Get the stored username
  Future<String?> getUsername() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString('username');
      print('Fetched username: $username');
      return username;
    } catch (e) {
      _debugException('getUsername', e);
      return null;
    }
  }

  /// Get the stored user's role (patient or doctor)
  Future<String?> getUserRole() async {
    final token = await getToken();
    if (token == null) {
      print('No token found. Cannot fetch user role.');
      return null;
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/pressure/users/profile'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Token $token", // Correct format
        },
      );

      _debugResponse('Get User Role', response);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['is_patient'] != null && data['is_doctor'] != null) {
          if (data['is_patient'] == true) {
            return 'patient';
          } else if (data['is_doctor'] == true) {
            return 'doctor';
          }
        }
        return 'unknown'; // Return 'unknown' if role is not identified
      } else {
        print('Failed to fetch user role.');
        return null;
      }
    } catch (e) {
      _debugException('getUserRole', e);
      return null;
    }
  }

  /// Add blood pressure reading for the logged-in user
  Future<bool> addBloodPressureRecord(double systolic, double diastolic) async {
    final token = await getToken();
    if (token == null) {
      print('No token found. Cannot add record.');
      return false;
    }

    final requestData = {
      "systolic": systolic,
      "diastolic": diastolic,
    };

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/pressure/readings/'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Token $token", // Correct format
        },
        body: jsonEncode(requestData),
      );

      _debugResponse('Add Blood Pressure Record', response);

      return response.statusCode == 201;
    } catch (e) {
      _debugException('addBloodPressureRecord', e);
      return false;
    }
  }

  /// Retrieve blood pressure records
  Future<List<dynamic>?> getBloodPressureRecords({String? patientUsername}) async {
    final token = await getToken();
    if (token == null) {
      print('No token found. Cannot fetch records.');
      return null;
    }

    final url = patientUsername != null
        ? '$baseUrl/pressure/readings/?username=$patientUsername'
        : '$baseUrl/pressure/readings/';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Token $token", // Correct format
        },
      );

      _debugResponse('Get Blood Pressure Records', response);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      _debugException('getBloodPressureRecords', e);
      return null;
    }
  }

  /// Logout user by removing the token and username from shared_preferences
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('username');
      print('User logged out successfully.');
    } catch (e) {
      _debugException('logout', e);
    }
  }

  /// Automatically refresh records when a new record is added
  Future<void> refreshRecords(Function(List<dynamic>) updateCallback) async {
    try {
      final records = await getBloodPressureRecords();
      if (records != null) {
        updateCallback(records);
      } else {
        print('No records to refresh.');
      }
    } catch (e) {
      _debugException('refreshRecords', e);
    }
  }

  /// Fetch health recommendations based on the logged-in user's blood pressure
  Future<Map<String, dynamic>?> fetchRecommendations() async {
    final token = await getToken();
    if (token == null) {
      print('No token found. Cannot fetch recommendations.');
      return null;
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/pressure/recommendations/'), // Replace with your actual endpoint
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Token $token", // Pass token for authentication
        },
      );

      _debugResponse('Fetch Recommendations', response);

      if (response.statusCode == 200) {
        // Return the recommendation data (assuming it returns a JSON object)
        return jsonDecode(response.body);
      } else {
        print('Failed to fetch recommendations');
        return null;
      }
    } catch (e) {
      _debugException('fetchRecommendations', e);
      return null;
    }
  }
}
