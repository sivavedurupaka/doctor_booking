import 'package:flutter/material.dart';
import '../models/doctor.dart';
import '../screens/doctor_details_screen.dart';
import '../screens/date_selection_screen.dart';
import '../screens/ChatScreen.dart';

class DoctorCard extends StatelessWidget {
  final Doctor doctor;

  const DoctorCard({super.key, required this.doctor, required Null Function() onBookNow, required Null Function() onChat});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            /// ✅ Doctor Profile Image (Handles Empty Image)
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

            /// ✅ Doctor Name, Specialty & Hospital (Clickable)
            Expanded(
              child: GestureDetector(
                onTap: () {
                  /// 🔥 Navigate to `DoctorDetailsScreen`
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DoctorDetailsScreen(doctor: doctor)),
                  );
                },
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
                      doctor.hospital,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

            /// ✅ Buttons Section (Book Now + Chat)
            Column(
              children: [
                /// ✅ "Book Now" Button
                ElevatedButton(
                  onPressed: () {
                    /// 🔥 Navigate to `DateSelectionScreen`
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DateSelectionScreen(doctor: doctor),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("Book Now"),
                ),
                const SizedBox(height: 8),

                /// ✅ "Chat" Button
                ElevatedButton(
                  onPressed: () {
                    /// 🔥 Navigate to `ChatScreen`
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          doctor: doctor,
                          doctorName: doctor.name,
                          specialty: doctor.specialty,
                          treatableDiseases: doctor.treatableDiseases,
                        ),
                      ),
                    );
                  },
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
