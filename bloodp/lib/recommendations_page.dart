import 'package:flutter/material.dart';
import 'api_service.dart';  // Import the ApiService

class RecommendationsPage extends StatelessWidget {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Health Recommendations")),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: apiService.fetchRecommendations(),  // Fetch recommendations
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            Map<String, dynamic> data = snapshot.data!;

            // Assuming the recommendations are a Map
            return ListView.builder(
              itemCount: data.length,  // The number of recommendations
              itemBuilder: (context, index) {
                String key = data.keys.elementAt(index);  // Recommendation key
                return ListTile(
                  title: Text("$key: ${data[key]}"),  // Display recommendation
                );
              },
            );
          } else {
            return Center(child: Text('No recommendations available.'));
          }
        },
      ),
    );
  }
}