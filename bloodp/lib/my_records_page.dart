import 'package:flutter/material.dart';

class MyRecordsPage extends StatelessWidget {
  final List<Map<String, dynamic>> records;

  MyRecordsPage({Key? key, required this.records}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Records'),
      ),
      body: records.isEmpty
          ? const Center(
              child: Text('No records found.'),
            )
          : ListView.builder(
              itemCount: records.length,
              itemBuilder: (context, index) {
                final record = records[index];
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text('Systolic: ${record['systolic']}'),
                    subtitle: Text('Diastolic: ${record['diastolic']}'),
                    trailing: Text(
                      '${record['date'].toLocal()}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
