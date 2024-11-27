import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'patient_records_page.dart';  // Adjust the import based on your file structure

class PatientListPage extends StatelessWidget {
  final String token;

  PatientListPage(this.token);

  Future<List<dynamic>> fetchPatients() async {
    final response = await http.get(
      Uri.parse('https://41dc-41-89-99-5.ngrok-free.app/pressure/patients/'),
      headers: {
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load patients');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Patient List')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: Text(
                'Welcome',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                // Handle logout action
                Navigator.pop(context); // Close the drawer
                // You can implement the logout logic here
                // For example, navigate to a login page:
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchPatients(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No patients available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final patient = snapshot.data![index];
                return ListTile(
                  title: Text(patient['username']),
                  onTap: () {
                    // Navigate to the patient's record page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PatientRecordPage(patient['username'], token),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
