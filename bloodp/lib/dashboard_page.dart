import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'set_reminders_page.dart';
import 'my_records_page.dart';
import 'recommendations_page.dart';
import 'add_records_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart'; // Import login page

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Map<String, dynamic>> _records = []; // Stores records fetched from the database
  List<Map<String, dynamic>> _reminders = []; // List to store reminders
  bool isLoading = false; // For loading state
  final String _username = "User"; // Placeholder username

  @override
  void initState() {
    super.initState();
    _fetchRecords(); // Fetch records from the database when the page loads
    _checkForUpcomingReminders();
  }

  Future<void> _fetchRecords() async {
    setState(() {
      isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('No token found. Please log in again.');
      }

      final response = await http.get(
        Uri.parse('https://41dc-41-89-99-5.ngrok-free.app/pressure/readings/'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Token $token",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          _records = data.map((record) {
            return {
              'id': record['id'] ?? 0, // Default to 0 if null
              'systolic': record['systolic'] ?? 0,
              'diastolic': record['diastolic'] ?? 0,
              'date_recorded': record['date_recorded'] != null
                  ? DateTime.parse(record['date_recorded'])
                  : DateTime.now(), // Fallback to current date if null
              'patient': record['patient'] != null ? record['patient'].toString() : 'Unknown', // Add patient if needed
            };
          }).toList();
        });
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized. Please log in again.');
      } else {
        throw Exception('Failed to load records. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }

    setState(() {
      isLoading = false;
    });
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
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }

  // Calculate health status based on systolic and diastolic readings
  String _getHealthStatus(int systolic, int diastolic) {
    if (systolic < 120 && diastolic < 80) {
      return 'Healthy';
    } else if (systolic < 130 && diastolic < 80) {
      return 'Average';
    } else {
      return 'High';
    }
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show a loading spinner
          : SingleChildScrollView(
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
                    
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddRecordsPage()),
          ).then((_) {
            // Refresh records after adding
            _fetchRecords();
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
                MaterialPageRoute(builder: (context) => const MyRecordsPage()),
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
            onTap: _logout,
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Text(
      'Good Morning, $_username',
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildKeyStatsOverview() {
    if (_records.isEmpty) {
      return const Center(child: Text('No Records Available.'));
    }
    final latestRecord = _records.last;
    String healthStatus = _getHealthStatus(latestRecord['systolic'], latestRecord['diastolic']);
    Color healthColor;

    switch (healthStatus) {
      case 'Healthy':
        healthColor = Colors.green;
        break;
      case 'Average':
        healthColor = Colors.orange;
        break;
      default:
        healthColor = Colors.red;
    }

    return Card(
      child: ListTile(
        title: Text('${latestRecord['systolic']} / ${latestRecord['diastolic']} mmHg'),
        subtitle: Text(healthStatus),
        trailing: Icon(Icons.health_and_safety, color: healthColor),
      ),
    );
  }


Widget _buildCombinationGraphSection() {
  if (_records.isEmpty) {
    return const Center(
      child: Text('No data available to display the chart.'),
    );
  }

  // Prepare data for the bar chart
  List<BarChartGroupData> barGroups = [];
  for (int i = 0; i < _records.length; i++) {
    final record = _records[i];
    barGroups.add(
      BarChartGroupData(
        x: i, // Use index as x-value
        barRods: [
          BarChartRodData(
            toY: record['systolic'].toDouble(),
            color: Colors.blue,
            width: 10,
          ),
          BarChartRodData(
            toY: record['diastolic'].toDouble(),
            color: Colors.green,
            width: 10,
          ),
        ],
        // Removed the showingTooltipIndicators to declutter the graph
      ),
    );
  }

  return Card(
    elevation: 4,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Blood Pressure Trends',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 300,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceBetween,
                maxY: _getMaxPressureValue(),
                minY: 0,
                barGroups: barGroups,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < 0 || value.toInt() >= _records.length) {
                          return const SizedBox.shrink();
                        }
                        final record = _records[value.toInt()];
                        final date = record['date_recorded'] as DateTime;
                        return Text(
                          '${date.day}/${date.month}', // Customize date format as needed
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.black12),
                ),
                barTouchData: BarTouchData(
                  enabled: false, // Disable interactivity for further decluttering
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// Helper function to get the max value for the y-axis
double _getMaxPressureValue() {
  if (_records.isEmpty) return 200.0; // Default max pressure value
  return _records.fold(0.0, (max, record) {
    final systolic = record['systolic'].toDouble();
    final diastolic = record['diastolic'].toDouble();
    return systolic > max ? systolic : (diastolic > max ? diastolic : max);
  }) + 20; // Add some padding to the max value
}

  Widget _buildReminderSection() {
  // Check if there are any reminders set
  if (_reminders.isEmpty) {
    return const Center(child: Text('No reminders set.'));
  }

  // Sort reminders by date/time to show the next upcoming reminder
  _reminders.sort((a, b) => a['dateTime'].compareTo(b['dateTime']));
  final nextReminder = _reminders.first;

  // Format the reminder's date and time for display
  final formattedDate = '${nextReminder['dateTime'].day}-${nextReminder['dateTime'].month}-${nextReminder['dateTime'].year}';
  final formattedTime = TimeOfDay.fromDateTime(nextReminder['dateTime']).format(context);

  return Card(
    elevation: 4,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upcoming Reminder',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            title: Text('Reminder: ${nextReminder['title']}'),
            subtitle: Text('At: $formattedDate at $formattedTime'),
            leading: const Icon(Icons.notifications),
          ),
        ],
      ),
    ),
  );
}
}