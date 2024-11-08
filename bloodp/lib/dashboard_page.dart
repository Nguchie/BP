import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'set_reminders_page.dart';
import 'my_records_page.dart';
import 'recommendations_page.dart';
import 'add_records_page.dart';
import 'reminders_page.dart';
import 'login_screen.dart'; // Import login page

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<Map<String, dynamic>> _records = []; // List to store the records
  final List<Map<String, dynamic>> _reminders = []; // List to store reminders

  @override
  void initState() {
    super.initState();
    _checkForUpcomingReminders();
  }

  void _checkForUpcomingReminders() {
    if (_reminders.isNotEmpty) {
      _reminders.sort((a, b) => a['dateTime'].compareTo(b['dateTime']));
      final nextReminder = _reminders.first;
      _showReminderNotification(nextReminder);
    }
  }

  void _showReminderNotification(Map<String, dynamic> reminder) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reminder!'),
        content: Text('You have a reminder: ${reminder['title']} at ${reminder['dateTime']}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _logout() {
    // Perform any logout logic, such as clearing session data
    // Navigate back to the login screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
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
              _buildCombinationGraphSection(),
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddRecordsPage()),
          ).then((newRecord) {
            if (newRecord != null) {
              setState(() {
                _records.add(newRecord);
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
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.alarm),
            title: const Text('Set Reminders'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SetRemindersPage()),
              ).then((reminder) {
                if (reminder != null) {
                  setState(() {
                    _reminders.add(reminder);
                    _checkForUpcomingReminders();
                  });
                }
              });
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
                MaterialPageRoute(builder: (context) => const RecommendationsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: _logout, // Call the _logout function
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
    if (_records.isEmpty) {
      return Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.teal,
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'No Records Available',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Please add a record to see your stats',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    var latestRecord = _records.last;
    double systolic = latestRecord['systolic'];
    double diastolic = latestRecord['diastolic'];
    String status = _getStatusForPressure(systolic, diastolic);
    Color statusColor = _getColorForPressure(systolic, diastolic);

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: statusColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$systolic / $diastolic mmHg',
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Status: $status',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCombinationGraphSection() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BarChart(
          BarChartData(
            barGroups: _getBarData(),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 20,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return Text(value.toStringAsFixed(0));
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      'Day ${value.toInt() + 1}',
                      style: const TextStyle(fontSize: 10),
                    );
                  },
                ),
              ),
            ),
            gridData: const FlGridData(show: false),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _getBarData() {
    return _records.asMap().entries.map((entry) {
      int index = entry.key;
      var record = entry.value;

      double systolic = record['systolic'] ?? 0.0;
      double diastolic = record['diastolic'] ?? 0.0;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: systolic,
            color: Colors.blue,
            width: 8,
          ),
          BarChartRodData(
            toY: diastolic,
            color: Colors.red,
            width: 8,
          ),
        ],
        barsSpace: 4,
      );
    }).toList();
  }

  Widget _buildReminderSection() {
    return _reminders.isEmpty
        ? const Text('No reminders set.')
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _reminders.map((reminder) {
              return ListTile(
                title: Text(reminder['title']),
                subtitle: Text(reminder['dateTime'].toString()),
              );
            }).toList(),
          );
  }

  Widget _buildRecommendationSection() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      color: Colors.orange[100],
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recommendations',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Try to maintain a healthy lifestyle by eating well and exercising regularly.',
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusForPressure(double systolic, double diastolic) {
    if (systolic < 120 && diastolic < 80) {
      return 'Normal';
    } else if (systolic < 140 && diastolic < 90) {
      return 'Elevated';
    } else {
      return 'High Blood Pressure';
    }
  }

  Color _getColorForPressure(double systolic, double diastolic) {
    if (systolic < 120 && diastolic < 80) {
      return Colors.green;
    } else if (systolic < 140 && diastolic < 90) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }
}
