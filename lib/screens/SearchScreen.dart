import 'package:flutter/material.dart';
import '../models/doctor.dart';
import '../widgets/doctor_card.dart';

class SearchScreen extends StatefulWidget {
  final List<Doctor> allDoctors;
  const SearchScreen({super.key, required this.allDoctors});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  List<Doctor> searchResults = [];

  @override
  void initState() {
    super.initState();
    searchResults = widget.allDoctors; // Initially, show all doctors
  }

  /// ✅ Search Function (Filter by Name, Specialty, or Disease)
  void _filterDoctors(String query) {
    setState(() {
      if (query.isEmpty) {
        searchResults = widget.allDoctors;
      } else {
        searchResults = widget.allDoctors.where((doctor) {
          final nameMatch = doctor.name.toLowerCase().contains(query.toLowerCase());
          final specialtyMatch = doctor.specialty.toLowerCase().contains(query.toLowerCase());
          final diseaseMatch = doctor.treatableDiseases.any(
                (disease) => disease.toLowerCase().contains(query.toLowerCase()),
              );

          return nameMatch || specialtyMatch || diseaseMatch;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Doctors")),
      body: Column(
        children: [
          /// 🔍 Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search by doctor, specialty, or disease...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          _filterDoctors('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: _filterDoctors,
            ),
          ),

          /// 🔹 Display Search Results
          Expanded(
            child: searchResults.isEmpty
                ? const Center(child: Text("No doctors found"))
                : ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      return DoctorCard(
                        doctor: searchResults[index],
                        onBookNow: () {
                          /// Navigate to booking page
                        }, onChat: () {  },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
