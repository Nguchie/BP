import 'package:flutter/material.dart';

class RemindersPage extends StatelessWidget {
  final List<Map<String, dynamic>> reminders;
  final Function(Map<String, dynamic>) onAddReminder;

  const RemindersPage({
    Key? key,
    required this.reminders,
    required this.onAddReminder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController dateController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Reminders'),
      ),
      body: ListView.builder(
        itemCount: reminders.length,
        itemBuilder: (context, index) {
          final reminder = reminders[index];
          return ListTile(
            title: Text(reminder['title']),
            subtitle: Text(reminder['dateTime'].toString()),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show dialog to add a new reminder
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Add Reminder'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(labelText: 'Reminder Title'),
                    ),
                    TextField(
                      controller: dateController,
                      decoration: InputDecoration(labelText: 'Date & Time (YYYY-MM-DD HH:MM)'),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      // Parse date from input
                      DateTime dateTime = DateTime.parse(dateController.text);
                      Map<String, dynamic> newReminder = {
                        'title': titleController.text,
                        'dateTime': dateTime,
                      };
                      onAddReminder(newReminder); // Call the callback
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
