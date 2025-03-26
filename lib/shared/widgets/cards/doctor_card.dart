import 'package:flutter/material.dart';
import '../models/doctor.dart';

class DoctorCard extends StatelessWidget {
  final Doctor doctor;
  final VoidCallback onBookNow;
  final VoidCallback onChat;

  const DoctorCard({
    super.key,
    required this.doctor,
    required this.onBookNow,
    required this.onChat,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Doctor Profile Image (if available)
            CircleAvatar(
              radius: 30,
              backgroundImage: doctor.profileImageUrl.isNotEmpty
                  ? NetworkImage(doctor.profileImageUrl)
                  : null,
              child: doctor.profileImageUrl.isEmpty
                  ? const Icon(Icons.person, size: 30, color: Colors.grey)
                  : null,
            ),
            const SizedBox(width: 12),

            // Doctor Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doctor.specialty,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Text(
                    doctor.location,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),

            // Buttons (Book Now + Chat)
            Column(
              children: [
                ElevatedButton(
                  onPressed: onBookNow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("Book Now"),
                ),
                const SizedBox(height: 8), // Space between buttons
                ElevatedButton(
                  onPressed: onChat,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
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
