import 'package:flutter/material.dart';

class RecommendationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommendations'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: const Text(
          'View your recommendations here.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
