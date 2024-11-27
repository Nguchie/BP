import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyRecordsPage extends StatefulWidget {
  const MyRecordsPage({super.key});

  @override
  _MyRecordsPageState createState() => _MyRecordsPageState();
}

class _MyRecordsPageState extends State<MyRecordsPage> {
  List<Map<String, dynamic>> records = [];
  bool isLoading = true;

  // Your Django server URL for fetching records
  final String _serverUrl = 'https://278b-197-232-162-143.ngrok-free.app/pressure/readings/'; // Adjust the URL accordingly

  // Method to fetch records from the backend
  Future<void> _fetchRecords() async {
    setState(() {
      isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('No token found. Please log in again.');
      }

      final response = await http.get(
        Uri.parse(_serverUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Token $token",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          records = data.map((record) {
            return {
              'id': record['id'] ?? 0, // Default to 0 if null
              'systolic': record['systolic'] ?? 0,
              'diastolic': record['diastolic'] ?? 0,
              'date_recorded': record['date_recorded'] != null
                  ? DateTime.parse(record['date_recorded'])
                  : DateTime.now(), // Fallback to current date if null
              'patient': record['patient'] ?? 'Unknown', // Add patient if needed
            };
          }).toList();
          isLoading = false;
        });
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized. Please log in again.');
      } else {
        throw Exception('Failed to load records. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Method to delete a record
  Future<void> _deleteRecord(int recordId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found. Please log in again.');
    }

    final response = await http.delete(
      Uri.parse('$_serverUrl$recordId/'), // Assuming your API uses the record ID in the URL
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Token $token",
      },
    );

    if (response.statusCode == 204) {
      setState(() {
        records.removeWhere((record) => record['id'] == recordId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Record deleted successfully.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete record.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchRecords(); // Fetch records when the page is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Records'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : records.isEmpty
              ? const Center(child: Text('No records found.'))
              : ListView.builder(
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    final record = records[index];
                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text('Systolic: ${record['systolic']}'),
                        subtitle: Text(
                          'Diastolic: ${record['diastolic']}\nRecorded on: ${record['date_recorded']?.toLocal() ?? DateTime.now().toLocal()}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Edit Button
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                // Navigate to the edit page (pass record data for editing)
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditRecordPage(record: record),
                                  ),
                                );
                              },
                            ),
                            // Delete Button
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                // Call the delete function
                                _deleteRecord(record['id']);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

// Edit Page for editing the record details
class EditRecordPage extends StatefulWidget {
  final Map<String, dynamic> record;

  const EditRecordPage({super.key, required this.record});

  @override
  _EditRecordPageState createState() => _EditRecordPageState();
}

class _EditRecordPageState extends State<EditRecordPage> {
  final TextEditingController _systolicController = TextEditingController();
  final TextEditingController _diastolicController = TextEditingController();
  final TextEditingController _patientController = TextEditingController();
  
  bool isLoading = false;

  // Server URL for updating the record
  final String _serverUrl = 'https://41dc-41-89-99-5.ngrok-free.app/pressure/readings/'; 

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing record data
    _systolicController.text = widget.record['systolic']?.toString() ?? '';  // Handle null or type mismatch
    _diastolicController.text = widget.record['diastolic']?.toString() ?? '';  // Handle null or type mismatch
    _patientController.text = widget.record['patient'].toString();  // Ensure it's a String

  }


  // Update the record in the backend
  Future<void> _updateRecord() async {
    setState(() {
      isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('No token found. Please log in again.');
    }

    try {
      final response = await http.put(
        Uri.parse('$_serverUrl${widget.record['id']}/'), // Use record ID in URL
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Token $token",
        },
        body: json.encode({
          'systolic': int.tryParse(_systolicController.text) ?? 0,
          'diastolic': int.tryParse(_diastolicController.text) ?? 0,
          'patient': _patientController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Record updated successfully.')),
        );
        Navigator.pop(context); // Go back to the records list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update record.')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Record')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Text('Editing record ID: ${widget.record['id']}'),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _systolicController,
                    decoration: const InputDecoration(
                      labelText: 'Systolic',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _diastolicController,
                    decoration: const InputDecoration(
                      labelText: 'Diastolic',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _patientController,
                    decoration: const InputDecoration(
                      labelText: 'Patient',
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _updateRecord,
                    child: const Text('Save Changes'),
                  ),
                ],
              ),
      ),
    );
  }
}