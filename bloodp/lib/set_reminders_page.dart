import 'package:flutter/material.dart';

class SetRemindersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Reminders'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: const Text(
          'Set your reminders here.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
