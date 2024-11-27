import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PatientRecordPage extends StatelessWidget {
  final String username;
  final String token;

  PatientRecordPage(this.username, this.token);

  Future<List<dynamic>> fetchPatientRecords() async {
    final response = await http.get(
      Uri.parse('https://41dc-41-89-99-5.ngrok-free.app/pressure/patient-records/$username/'),
      headers: {
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print('Response data: $data');  // Log the response to check the structure
      return data;
    } else {
      throw Exception('Failed to load patient records');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Patient Records: $username')),
      body: FutureBuilder<List<dynamic>>(
        future: fetchPatientRecords(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No records found for $username'));
          } else {
            final records = snapshot.data!;
            return ListView.builder(
              itemCount: records.length,
              itemBuilder: (context, index) {
                // Access the systolic, diastolic, and date_recorded fields
                var record = records[index];
                return ListTile(
                  title: Text('Record ${index + 1}'),
                  subtitle: Text(
                    'Systolic: ${record['systolic']} | Diastolic: ${record['diastolic']}\nDate Recorded: ${record['date_recorded']}',
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
