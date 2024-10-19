import 'package:flutter/material.dart';
import 'set_reminders_page.dart';
import 'my_records_page.dart';
import 'recommendations_page.dart';
import 'add_records_page.dart'; // Import the AddRecordsPage

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<Map<String, dynamic>> _records = []; // List to store the records

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.teal),
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeSection(),
              const SizedBox(height: 20),
              _buildKeyStatsOverview(),
              const SizedBox(height: 20),
              _buildGraphPlaceholder(),
              const SizedBox(height: 20),
              _buildReminderSection(),
              const SizedBox(height: 20),
              _buildRecommendationSection(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to Add Records page and handle the result
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddRecordsPage()),
          ).then((newRecord) {
            if (newRecord != null) {
              setState(() {
                _records.add(newRecord); // Add the new record to the records list
              });
            }
          });
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Record'),
        tooltip: 'Add Record',
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.teal,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.alarm),
            title: const Text('Set Reminders'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SetRemindersPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.assessment),
            title: const Text('My Records'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyRecordsPage(records: _records),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.recommend),
            title: const Text('Recommendations'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RecommendationsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: () {
              // Add log out logic
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return const Text(
      'Good Morning, User',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildKeyStatsOverview() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.teal,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              '100 mmHg',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Pulse: 70 BPM',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Status: Normal',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGraphPlaceholder() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          'Graph Placeholder',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildRecommendationSection() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: const Text('Recommendations'),
        subtitle: const Text('Tap to view your personalized recommendations'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Add navigation logic for recommendations
        },
      ),
    );
  }

  Widget _buildReminderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upcoming Reminders',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: const Text('Take Blood Pressure'),
            subtitle: const Text('19/03/2024 - 22:38'),
            trailing: const Icon(Icons.alarm),
            onTap: () {
              // Handle reminder tap
            },
          ),
        ),
      ],
    );
  }
}
