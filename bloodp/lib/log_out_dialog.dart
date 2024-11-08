import 'package:flutter/material.dart';
import 'package:bloodp/api_service.dart'; // Update with your actual import
import 'login_screen.dart'; // Update with your actual import

class LogOutDialog {
  static Future<void> showLogOutDialog(BuildContext context) async {
    final apiService = ApiService();

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Log Out'),
              onPressed: () async {
                // Call logout method from ApiService
                await apiService.logout();

                // Navigate back to login screen
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
