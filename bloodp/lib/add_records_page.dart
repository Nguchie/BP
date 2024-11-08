import 'package:flutter/material.dart';

class AddRecordsPage extends StatefulWidget {
  const AddRecordsPage({super.key});

  @override
  _AddRecordsPageState createState() => _AddRecordsPageState();
}

class _AddRecordsPageState extends State<AddRecordsPage> {
  final TextEditingController _systolicController = TextEditingController();
  final TextEditingController _diastolicController = TextEditingController();

 void _saveRecord() {
  final systolic = int.tryParse(_systolicController.text);
  final diastolic = int.tryParse(_diastolicController.text);

  if (systolic != null && diastolic != null) {
    // Convert integers to doubles if needed
    Navigator.pop(context, {
      'systolic': systolic.toDouble(),  // Convert to double
      'diastolic': diastolic.toDouble(), // Convert to double
      'date': DateTime.now(),
    });
  } else {
    // Show an error message
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
