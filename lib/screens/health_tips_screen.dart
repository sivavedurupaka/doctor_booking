import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class HealthTipsScreen extends StatefulWidget {
  const HealthTipsScreen({super.key});

  @override
  _HealthTipsScreenState createState() => _HealthTipsScreenState();
}

class _HealthTipsScreenState extends State<HealthTipsScreen> {
  List<Map<String, String>> mentalHealthTips = [];
  List<Map<String, String>> physicalHealthTips = [];
  List<Map<String, String>> emotionalHealthTips = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadHealthTips();
  }

  /// ✅ Load health tips from JSON file
  Future<void> loadHealthTips() async {
    try {
      String jsonString = await rootBundle.loadString('assets/data/health_tips.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      setState(() {
        mentalHealthTips = List<Map<String, String>>.from(
            jsonData['mental_health_tips'].map((tip) => Map<String, String>.from(tip)));
        physicalHealthTips = List<Map<String, String>>.from(
            jsonData['physical_health_tips'].map((tip) => Map<String, String>.from(tip)));
        emotionalHealthTips = List<Map<String, String>>.from(
            jsonData['emotional_health_tips'].map((tip) => Map<String, String>.from(tip)));
        isLoading = false;
      });
    } catch (e) {
      print("Error loading health tips: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Health Tips'),
          bottom: const TabBar(
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: "Mental Health"),
              Tab(text: "Physical Health"),
              Tab(text: "Emotional Health"),
            ],
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildHealthTipsList(mentalHealthTips),
                  _buildHealthTipsList(physicalHealthTips),
                  _buildHealthTipsList(emotionalHealthTips),
                ],
              ),
      ),
    );
  }

  /// ✅ Widget to display health tips in a ListView
  Widget _buildHealthTipsList(List<Map<String, String>> tips) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tips.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            title: Text(
              tips[index]['title'] ?? '',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black54),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TipDetailScreen(
                    title: tips[index]['title'] ?? '',
                    description: tips[index]['description'] ?? '',
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

/// ✅ Detailed Screen for each tip
class TipDetailScreen extends StatelessWidget {
  final String title;
  final String description;

  const TipDetailScreen({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
