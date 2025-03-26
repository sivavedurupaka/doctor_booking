import 'package:doctor_booking/screens/ChatScreen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

import '../models/doctor.dart';
import '../widgets/doctor_card.dart';
import 'date_selection_screen.dart';
// Import Chat Screen

class CardiologyScreen extends StatefulWidget {
  const CardiologyScreen({super.key});

  @override
  _CardiologyScreenState createState() => _CardiologyScreenState();
}

class _CardiologyScreenState extends State<CardiologyScreen> {
  List<Doctor> cardiologyDoctors = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCardiologyDoctors();
  }

  /// ✅ Load doctors from `cardiology.json`
  Future<void> loadCardiologyDoctors() async {
    try {
      String jsonString = await rootBundle.loadString('assets/data/cardiology.json');
      final jsonData = json.decode(jsonString);

      if (jsonData['doctors'] != null) {
        List<Doctor> doctorList = Doctor.fromJsonList(jsonData['doctors']);

        setState(() {
          cardiologyDoctors = doctorList;
          isLoading = false;
        });
      } else {
        throw Exception("Missing 'doctors' key in JSON");
      }
    } catch (e) {
      print("Error loading cardiology doctors: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cardiology Specialists'),
        backgroundColor: Colors.redAccent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cardiologyDoctors.isEmpty
              ? const Center(
                  child: Text(
                    'No Cardiology doctors found.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: cardiologyDoctors.length,
                  itemBuilder: (context, index) {
                    Doctor doctor = cardiologyDoctors[index];
                    return DoctorCard(
                      doctor: doctor,
                      onBookNow: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DateSelectionScreen(doctor: doctor),
                          ),
                        );
                      },
                      onChat: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(doctor: doctor, doctorName: '', specialty: '', treatableDiseases: [],),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
