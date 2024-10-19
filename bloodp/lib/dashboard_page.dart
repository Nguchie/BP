import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.teal,
      ),
      drawer: _buildDrawer(),
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
              _buildRecommendationSection(),
              const SizedBox(height: 20),
              _buildReminderSection(),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {
              // Add your navigation logic for adding a record here
            },
            child: const Text(
              'Add Record',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            onPressed: () {
              // Add your navigation logic for adding a record here
            },
            child: const Icon(Icons.add),
            backgroundColor: Colors.teal,
            tooltip: 'Add Record',
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
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
              // Add navigation logic if needed
            },
          ),
          ListTile(
            leading: const Icon(Icons.alarm),
            title: const Text('Set Reminders'),
            onTap: () {
              // Add navigation logic if needed
            },
          ),
          ListTile(
            leading: const Icon(Icons.assessment),
            title: const Text('My Records'),
            onTap: () {
              // Add navigation logic if needed
            },
          ),
          ListTile(
            leading: const Icon(Icons.recommend),
            title: const Text('Recommendations'),
            onTap: () {
              // Add navigation logic if needed
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
      'Good Morning, Evah',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildKeyStatsOverview() {
    return Card(
      elevation: 5, // Added elevation
      color: Colors.teal,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              '100 mmHg',
              style: TextStyle(
                fontSize: 36, // Increased font size
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4), // Added spacing
            Text(
              'Pulse: 70 BPM',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4), // Added spacing
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
      elevation: 5, // Added elevation
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
            fontSize: 20, // Increased font size
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Card(
          elevation: 5, // Added elevation
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
