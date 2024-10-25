import 'package:flutter/material.dart';

class RecommendationsPage extends StatelessWidget {
  const RecommendationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommendations'),
        backgroundColor: Colors.teal,
      ),
      body: const Center(
        child: Text(
          'View your recommendations here.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
