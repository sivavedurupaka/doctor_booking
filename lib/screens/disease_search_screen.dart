import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DiseaseSearchScreen extends StatefulWidget {
  const DiseaseSearchScreen({super.key});

  @override
  _DiseaseSearchScreenState createState() => _DiseaseSearchScreenState();
}

class _DiseaseSearchScreenState extends State<DiseaseSearchScreen> {
  List<dynamic> diseases = [];
  List<dynamic> filteredDiseases = [];
  List<dynamic> doctors = [];
  List<dynamic> filteredDoctors = [];

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  // Load JSON file from assets
  Future<void> loadJsonData() async {
    String jsonString = await rootBundle.loadString('assets/diseases.json');
    final jsonData = json.decode(jsonString);
    setState(() {
      diseases = jsonData['diseases'];
      doctors = jsonData['doctors'];
    });
  }

  // Search function
  void searchDisease(String query) {
    List<dynamic> results = [];
    List<dynamic> doctorResults = [];

    if (query.isNotEmpty) {
      // Filter diseases based on query
      results = diseases.where((disease) =>
          disease['name'].toLowerCase().contains(query.toLowerCase())).toList();

      // Extract specialists related to the searched disease
      List<String> matchedSpecialists = results
          .map<String>((disease) => disease['specialist'].toLowerCase())
          .toList();

      // Filter doctors based on the extracted specialists
      doctorResults = doctors.where((doctor) =>
          matchedSpecialists.any((specialty) =>
              doctor['specialty'].toLowerCase().contains(specialty))).toList();
    }

    setState(() {
      filteredDiseases = results;
      filteredDoctors = doctorResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Disease")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: searchDisease,
              decoration: const InputDecoration(
                labelText: "Search Disease",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                if (filteredDiseases.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Diseases",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...filteredDiseases.map((disease) => Card(
                        margin: const EdgeInsets.all(10),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                disease['name'],
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              Text(disease['description']),
                            ],
                          ),
                        ),
                      )),
                ],
                if (filteredDoctors.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Doctors",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...filteredDoctors.map((doctor) => Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(doctor['imageUrl']),
                          ),
                          title: Text(doctor['name']),
                          subtitle: Text(
                              "${doctor['specialty']} - ${doctor['location']}"),
                        ),
                      )),
                ],
                if (filteredDoctors.isEmpty && filteredDiseases.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "No doctors found for this disease.",
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
