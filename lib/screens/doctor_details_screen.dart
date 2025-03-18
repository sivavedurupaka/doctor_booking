import 'package:flutter/material.dart';
import '../models/doctor.dart';
import 'date_selection_screen.dart';

class DoctorDetailsScreen extends StatelessWidget {
  final Doctor doctor;

  const DoctorDetailsScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(doctor.name)),
      body: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: doctor.profileImageUrl.isNotEmpty
                ? NetworkImage(doctor.profileImageUrl)
                : null,
            child: doctor.profileImageUrl.isEmpty ? const Icon(Icons.person, size: 50) : null,
          ),
          const SizedBox(height: 20),
          Text(
            doctor.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            doctor.specialty,
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DateSelectionScreen(doctor: doctor, dentist: null,),
                ),
              );
            },
            child: const Text('Book Appointment'),
          ),
        ],
      ),
    );
  }
}
