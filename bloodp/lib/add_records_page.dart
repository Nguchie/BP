import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart'; // Ensure you import your ApiService

class AddRecordsPage extends StatefulWidget {
  const AddRecordsPage({super.key});

  @override
  _AddRecordsPageState createState() => _AddRecordsPageState();
}

class _AddRecordsPageState extends State<AddRecordsPage> {
  final TextEditingController _systolicController = TextEditingController();
  final TextEditingController _diastolicController = TextEditingController();

  final ApiService _apiService = ApiService();  // Create an instance of ApiService

  // Function to get the authentication token from SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');  // Assuming the token is stored with the key 'token'
  }

  // Function to save the blood pressure record
  Future<void> _saveRecord() async {
    final systolic = int.tryParse(_systolicController.text);
    final diastolic = int.tryParse(_diastolicController.text);

    if (systolic != null && diastolic != null) {
      final token = await _getToken();  // Retrieve the token

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No authentication token found. Please log in again.'),
          ),
        );
        return;
      }

      // Call the API service to add the record
      final success = await _apiService.addBloodPressureRecord(
        systolic.toDouble(),
        diastolic.toDouble(),
          // Pass the token to the API service
      );

      if (success) {
        // If the record is added successfully, show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Record added successfully!'),
          ),
        );
        Navigator.pop(context); // Close the page
      } else {
        // Show an error message if the record could not be added
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add the record. Please try again later.'),
          ),
        );
      }
    } else {
      // Show an error message if the input is invalid
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter valid numbers.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Record'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _systolicController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Systolic (e.g., 120)',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _diastolicController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Diastolic (e.g., 80)',
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveRecord,
              child: const Text('Save Record'),
            ),
          ],
        ),
      ),
    );
  }
}
