import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/doctor.dart';
import '../widgets/doctor_card.dart';
import 'date_selection_screen.dart';

class AnesthesiologyScreen extends StatefulWidget {
  const AnesthesiologyScreen({super.key});

  @override
  _AnesthesiologyScreenState createState() => _AnesthesiologyScreenState();
}

class _AnesthesiologyScreenState extends State<AnesthesiologyScreen> {
  List<Doctor> anesthesiologyDoctors = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAnesthesiologyDoctors();
  }

  /// ✅ Load doctors from `anesthesiology.json`
  Future<void> loadAnesthesiologyDoctors() async {
    try {
      String jsonString = await rootBundle.loadString('assets/data/anesthesiology.json');
      final jsonData = json.decode(jsonString);

      if (jsonData['doctors'] != null) {
        List<Doctor> doctorList = Doctor.fromJsonList(jsonData['doctors']);

        setState(() {
          anesthesiologyDoctors = doctorList;
          isLoading = false;
        });
      } else {
        throw Exception("Missing 'doctors' key in JSON");
      }
    } catch (e) {
      print("Error loading anesthesiology doctors: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Anesthesiology Specialists')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : anesthesiologyDoctors.isEmpty
              ? const Center(
                  child: Text(
                    'No Anesthesiology doctors found.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: anesthesiologyDoctors.length,
                  itemBuilder: (context, index) {
                    return DoctorCard(
                      doctor: anesthesiologyDoctors[index],
                      onBookNow: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DateSelectionScreen(doctor: anesthesiologyDoctors[index], dentist: null),
                          ),
                        );
                      }, onChat: () {  },
                    );
                  },
                ),
    );
  }
}
