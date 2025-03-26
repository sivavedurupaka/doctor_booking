import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/doctor.dart';
import '../widgets/doctor_card.dart';
import 'date_selection_screen.dart';

class DermatologyScreen extends StatefulWidget {
  const DermatologyScreen({super.key});

  @override
  _DermatologyScreenState createState() => _DermatologyScreenState();
}

class _DermatologyScreenState extends State<DermatologyScreen> {
  List<Doctor> dermatologyDoctors = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDermatologyDoctors();
  }

  /// ✅ Load doctors from `dermatology.json`
  Future<void> loadDermatologyDoctors() async {
    try {
      String jsonString = await rootBundle.loadString('assets/data/dermatology.json');
      final jsonData = json.decode(jsonString);

      if (jsonData.containsKey('doctors')) {
        setState(() {
          dermatologyDoctors = Doctor.fromJsonList(jsonData['doctors']);
          isLoading = false;
        });
      } else {
        throw Exception("Missing 'doctors' key in JSON");
      }
    } catch (e) {
      print("Error loading dermatology doctors: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dermatology Specialists')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : dermatologyDoctors.isEmpty
              ? const Center(child: Text("No dermatology specialists available."))
              : ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: dermatologyDoctors.length,
                  itemBuilder: (context, index) {
                    return DoctorCard(
                      doctor: dermatologyDoctors[index],
                      onBookNow: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DateSelectionScreen(doctor: dermatologyDoctors[index]),
                          ),
                        );
                      }, onChat: () {  },
                    );
                  },
                ),
    );
  }
}
