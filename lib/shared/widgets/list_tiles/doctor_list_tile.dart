import 'package:doctor_booking/screens/date_selection_screen.dart';
import 'package:flutter/material.dart';
import '../models/doctor.dart';

class DoctorListTile extends StatelessWidget {
  final Doctor doctor;

  const DoctorListTile({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: (doctor.profileImageUrl.isNotEmpty)
              ? NetworkImage(doctor.profileImageUrl)
              : null,
          child: (doctor.profileImageUrl.isEmpty) ? const Icon(Icons.person, size: 30) : null,
        ),
        title: Text(doctor.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(doctor.specialty),
        trailing: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DateSelectionScreen(doctor: doctor),
              ),
            );
          },
          child: const Text("Book Now"),
        ),
      ),
    );
  }
}
