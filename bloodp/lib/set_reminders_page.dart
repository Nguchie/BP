import 'package:flutter/material.dart';

class SetRemindersPage extends StatefulWidget {
  const SetRemindersPage({super.key});

  @override
  _SetRemindersPageState createState() => _SetRemindersPageState();
}

class _SetRemindersPageState extends State<SetRemindersPage> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final TextEditingController _reminderController = TextEditingController();

  /// Combines the selected date and time into a single `DateTime` object.
  DateTime? get _combinedDateTime {
    if (_selectedDate == null || _selectedTime == null) return null;
    return DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );
  }

  /// Handles setting and saving the reminder.
  void _setReminder() {
    final dateTime = _combinedDateTime;
    if (dateTime != null && _reminderController.text.isNotEmpty) {
      // Prepare the reminder as a map
      final reminder = {
        'title': _reminderController.text,
        'dateTime': dateTime,
      };

      // Print to debug and return to the dashboard
      print('Reminder Set: $reminder');
      Navigator.pop(context, reminder);
    } else {
      // Show an error if fields are incomplete
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill in all fields!'),
      ));
    }
  }

  /// Handles date selection using the `showDatePicker`.
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  /// Handles time selection using the `showTimePicker`.
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Reminder'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Reminder Description Field
            const Text(
              'Reminder Description',
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              controller: _reminderController,
              decoration: const InputDecoration(hintText: 'Enter reminder details'),
            ),
            const SizedBox(height: 20),

            // Date Selection
            const Text(
              'Select Date',
              style: TextStyle(fontSize: 18),
            ),
            Row(
              children: [
                Text(_selectedDate == null
                    ? 'No date selected'
                    : '${_selectedDate!.toLocal()}'.split(' ')[0]),
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: const Text('Select Date'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Time Selection
            const Text(
              'Select Time',
              style: TextStyle(fontSize: 18),
            ),
            Row(
              children: [
                Text(_selectedTime == null
                    ? 'No time selected'
                    : _selectedTime!.format(context)),
                TextButton(
                  onPressed: () => _selectTime(context),
                  child: const Text('Select Time'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Set Reminder Button
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
