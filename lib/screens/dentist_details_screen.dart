import 'package:flutter/material.dart';
import '../models/dentist.dart';
import 'date_selection_screen.dart';

class DentistDetailsScreen extends StatelessWidget {
  final Dentist dentist;

  const DentistDetailsScreen({Key? key, required this.dentist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dr. ${dentist.name}"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// 🟣 **Profile Picture**
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.purple[100],
                backgroundImage: dentist.imageUrl.isNotEmpty
                    ? NetworkImage(dentist.imageUrl)
                    : null,
                child: dentist.imageUrl.isEmpty
                    ? const Icon(Icons.person, size: 50, color: Colors.grey)
                    : null,
              ),
              const SizedBox(height: 10),

              /// 🩺 **Doctor Name & Specialization**
              Text(
                "Dr. ${dentist.name}",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                dentist.specialty,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              /// 🏥 **Hospital Section**
              _infoCard(Icons.local_hospital, "Hospital", dentist.hospital, Colors.red[100]!),

              /// 📞 **Contact Section**
              _infoCard(Icons.phone, "Contact", dentist.phone, Colors.green[100]!),

              /// ⭐ **Experience Section**
              _infoCard(Icons.star, "Experience", "${dentist.experience} years", Colors.orange[100]!),

              const SizedBox(height: 10),

              /// 💊 **Treatable Diseases**
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Treatable Diseases:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                children: dentist.treatableDiseases.map((disease) {
                  return Chip(
                    label: Text(disease),
                    backgroundColor: Colors.blue[100],
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              /// 📅 **Book Now Button**
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DateSelectionScreen(
                          doctor: null,
                          dentist: dentist,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text("Book Now", style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// **Reusable UI Card for Information Display**
  Widget _infoCard(IconData icon, String title, String value, Color bgColor) {
    return Card(
      color: bgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: Colors.black54),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }
}
