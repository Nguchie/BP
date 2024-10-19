import 'package:flutter/material.dart';

class SetRemindersPage extends StatefulWidget {
  @override
  _SetRemindersPageState createState() => _SetRemindersPageState();
}

class _SetRemindersPageState extends State<SetRemindersPage> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final TextEditingController _reminderController = TextEditingController();

  void _setReminder() {
    if (_selectedDate != null && _selectedTime != null && _reminderController.text.isNotEmpty) {
      // Add your logic to save the reminder, e.g., store in a database or a list
      final reminder = {
        'date': _selectedDate,
        'time': _selectedTime,
        'description': _reminderController.text,
      };
      // For demonstration, we'll just show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Reminder set for ${_selectedDate!.toLocal()} at ${_selectedTime!.format(context)}: ${_reminderController.text}'),
      ));

      // Optionally navigate back to the dashboard
      Navigator.pop(context);
    } else {
      // Show an error if fields are incomplete
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill in all fields!'),
      ));
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Reminders'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reminder Description',
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              controller: _reminderController,
              decoration: const InputDecoration(hintText: 'Enter reminder details'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Date',
              style: TextStyle(fontSize: 18),
            ),
            Row(
              children: [
                Text(_selectedDate == null ? 'No date selected' : '${_selectedDate!.toLocal()}'.split(' ')[0]),
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: const Text('Select Date'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Time',
              style: TextStyle(fontSize: 18),
            ),
            Row(
              children: [
                Text(_selectedTime == null ? 'No time selected' : _selectedTime!.format(context)),
                TextButton(
                  onPressed: () => _selectTime(context),
                  child: const Text('Select Time'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _setReminder,
              child: const Text('Set Reminder'),
            ),
          ],
        ),
      ),
    );
  }
}
