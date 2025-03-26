import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/dentist.dart';
import '../repositories/dentist_repository.dart';
import '../screens/date_selection_screen.dart';
import '../screens/ChatScreen.dart';
import '../screens/dentist_details_screen.dart'; // ✅ Dentist Details Screen

class DentistScreen extends StatefulWidget {
  const DentistScreen({super.key});

  @override
  _DentistScreenState createState() => _DentistScreenState();
}

class _DentistScreenState extends State<DentistScreen> {
  final DentistRepository _repository = DentistRepository();
  List<Dentist> _dentists = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDentists();
  }

  Future<void> _loadDentists() async {
    List<Dentist> dentists = await _repository.loadDentists();
    setState(() {
      _dentists = dentists;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dentists in Kakinada')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _dentists.length,
              itemBuilder: (context, index) {
                Dentist dentist = _dentists[index];
                return GestureDetector(
                  onTap: () {
                    // ✅ Open Dentist Details Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DentistDetailsScreen(dentist: dentist),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// ✅ Dentist Profile Section
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: dentist.imageUrl.isNotEmpty
                                ? NetworkImage(dentist.imageUrl)
                                : null,
                            child: dentist.imageUrl.isEmpty
                                ? const Icon(Icons.person, size: 30, color: Colors.grey)
                                : null,
                          ),
                          const SizedBox(width: 12),

                          /// ✅ Dentist Info (Expanded for Proper Layout)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dentist.name,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  dentist.type,
                                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),

                          /// ✅ Buttons Column (Book Now on Top, Chat Below)
                          Column(
                            children: [
                              /// 📅 Book Now Button (Top Right Corner)
                              ElevatedButton(
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
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text("Book Now"),
                              ),

                              const SizedBox(height: 8), // Space between buttons

                              /// 🗨️ Chat Button (Below Book Now)
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                        doctorName: dentist.name,
                                        specialty: dentist.type,
                                        treatableDiseases: [],
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
                  ),
                );
              },
            ),
    );
  }
}