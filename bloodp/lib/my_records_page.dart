import 'package:flutter/material.dart';

class MyRecordsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Records'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: const Text(
          'View your records here.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
