//import 'package:doctor_booking/shared/widgets/models/dentist.dart';
import 'package:flutter/material.dart';
import '../models/dentist.dart';
import '../repositories/dentist_repository.dart';
import 'date_selection_screen.dart'; // Import Date Selection Screen

class DentistScreen extends StatefulWidget {
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
              itemCount: _dentists.length,
              itemBuilder: (context, index) {
                Dentist dentist = _dentists[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: dentist.imageUrl.isNotEmpty
                          ? NetworkImage(dentist.imageUrl)
                          : null,
                      child: dentist.imageUrl.isEmpty
                          ? const Icon(Icons.person, size: 30)
                          : null,
                    ),
                    title: Text(dentist.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(dentist.type ?? 'General Dentist'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // Navigate to Date Selection Screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DateSelectionScreen(doctor: null, dentist: dentist),
                          ),
                        );
                      },
                      child: const Text("Book Now"),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
