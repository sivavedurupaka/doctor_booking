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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// ✅ Doctor Image (Centered)
            CircleAvatar(
              radius: 70,
              backgroundImage: doctor.profileImageUrl.isNotEmpty 
                  ? NetworkImage(doctor.profileImageUrl) 
                  : null,
              child: doctor.profileImageUrl.isEmpty 
                  ? const Icon(Icons.person, size: 70, color: Colors.grey) 
                  : null,
            ),
            const SizedBox(height: 20),

            /// ✅ Doctor Name & Specialty
            Text(
              doctor.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              doctor.specialty,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            /// ✅ Doctor Info Cards
            _buildInfoCard(
              icon: Icons.local_hospital,
              label: "Hospital",
              value: doctor.hospital,
              color: Colors.red.shade100,
            ),
            _buildInfoCard(
              icon: Icons.phone,
              label: "Contact",
              value: doctor.contact,
              color: Colors.green.shade100,
            ),
            _buildInfoCard(
              icon: Icons.star,
              label: "Experience",
              value: "${doctor.experience} years",
              color: Colors.orange.shade100,
            ),
            _buildInfoCard(
              icon: Icons.location_on,
              label: "Location",
              value: doctor.location,
              color: Colors.blue.shade100,
            ),
            _buildInfoCard(
              icon: Icons.category,
              label: "Category",
              value: doctor.category,
              color: Colors.purple.shade100,
            ),

            /// ✅ **Treatable Diseases Title**
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Treatable Diseases:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),

            /// ✅ **Treatable Diseases List**
            Wrap(
              spacing: 8,
              children: doctor.treatableDiseases.map((disease) {
                return Chip(
                  label: Text(disease, style: const TextStyle(fontSize: 14)),
                  backgroundColor: Colors.blue.shade100,
                );
              }).toList(),
            ),
            const SizedBox(height: 30),

            /// ✅ Book Now Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DateSelectionScreen(doctor: doctor),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                backgroundColor: Colors.blue,
              ),
              child: const Text("Book Now", style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ Helper Method for Info Cards
  Widget _buildInfoCard({required IconData icon, required String label, required String value, required Color color}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      color: color,
      child: ListTile(
        leading: Icon(icon, color: Colors.black54),
        title: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        subtitle: Text(value, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
