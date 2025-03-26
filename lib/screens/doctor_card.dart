import 'package:flutter/material.dart';
import '../models/doctor.dart';
import '../screens/date_selection_screen.dart';
import '../screens/ChatScreen.dart';

class DoctorCard extends StatelessWidget {
  final Doctor doctor;

  const DoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(doctor.profileImageUrl),
                  radius: 30,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      doctor.specialty,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    Text(
                      doctor.hospital,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// ✅ "Book Now" Button
                ElevatedButton(
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

                /// ✅ "Chat" Button (Fixed)
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          doctor: doctor,
                          doctorName: doctor.name, // ✅ Pass doctor name
                          specialty: doctor.specialty, // ✅ Pass specialty
                          treatableDiseases: doctor.treatableDiseases.isNotEmpty
                              ? doctor.treatableDiseases
                              : ["No data available"], // ✅ Ensure list is not empty
                        ),
                      ),
                    );
                  },
                  child: const Text("Chat"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
