import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/doctor.dart';
import '../widgets/doctor_card.dart';
import 'date_selection_screen.dart';
import 'dentist_screen.dart';
import 'cardiology_screen.dart';
import 'dermatology_screen.dart';
import 'anesthesiology_screen.dart';
import 'health_tips_screen.dart';
import 'profile_screen.dart';
import 'user_bookings_screen.dart';
import 'ChatScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Doctor> doctors = [];
  List<Doctor> filteredDoctors = [];
  bool isLoading = true;
  int _selectedIndex = 0;
  TextEditingController searchController = TextEditingController();
  String fullName = "Siva"; // Default name

  @override
  void initState() {
    super.initState();
    loadDoctors();
    fetchUserFullName();
  }

  /// ✅ Fetch User Full Name from Firebase Auth
  Future<void> fetchUserFullName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        fullName = user.displayName ?? "Siva";
      });
    }
  }

  /// ✅ Load doctors from JSON asynchronously
  Future<void> loadDoctors() async {
    try {
      String jsonString = await rootBundle.loadString('assets/data/doctors.json');
      final jsonData = json.decode(jsonString);

      if (jsonData['doctors'] != null) {
        List<Doctor> doctorList = Doctor.fromJsonList(jsonData['doctors']);

        setState(() {
          doctors = doctorList;
          filteredDoctors = doctorList;
          isLoading = false;
        });
      } else {
        throw Exception("Missing 'doctors' key in JSON");
      }
    } catch (e) {
      print("Error loading doctors: $e");
      setState(() => isLoading = false);
    }
  }

  /// ✅ Search Function (Now Works with Diseases!)
  void _filterDoctors(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredDoctors = doctors;
      } else {
        query = query.toLowerCase();
        filteredDoctors = doctors.where((doctor) {
          final nameMatch = doctor.name.toLowerCase().contains(query);
          final specialtyMatch = doctor.specialty.toLowerCase().contains(query);
          final diseaseMatch = doctor.treatableDiseases.any(
            (disease) => disease.toLowerCase().contains(query),
          );

          return nameMatch || specialtyMatch || diseaseMatch;
        }).toList();
      }
    });
  }

  /// ✅ Handles bottom navigation tap
  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatScreen(doctorName: '', specialty: '', treatableDiseases: [],)));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const UserBookingsScreen()));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doctor Booking App')),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Welcome, $fullName',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),

                /// ✅ Search Bar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by doctor, specialty, or disease...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: _filterDoctors,
                  ),
                ),

                /// ✅ Categories Section
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Categories',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _categoryIcon(Icons.person, 'Anesthesiology', context, AnesthesiologyScreen()),
                    _categoryIcon(Icons.favorite, 'Cardiology', context, CardiologyScreen()),
                    _categoryIcon(Icons.medical_services, 'Dentist', context, DentistScreen()),
                    _categoryIcon(Icons.shield, 'Dermatology', context, DermatologyScreen()),
                    _categoryIcon(Icons.health_and_safety, 'Health Tips', context, HealthTipsScreen()),
                  ],
                ),

                /// ✅ Doctors List
                Expanded(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : filteredDoctors.isEmpty
                          ? const Center(child: Text("No doctors found"))
                          : ListView.builder(
                              itemCount: filteredDoctors.length,
                              itemBuilder: (context, index) {
                                return DoctorCard(
                                  doctor: filteredDoctors[index],
                                  onBookNow: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DateSelectionScreen(doctor: filteredDoctors[index]),
                                      ),
                                    );
                                  },
                                  onChat: () {},
                                );
                              },
                            ),
                ),
              ],
            ),

            /// ✅ Lottie Animation (Moved More Upwards)
            Positioned(
              top: -10, // 🔥 Moved further up
              right: 5,
              child: SizedBox(
                width: 80, // Adjusted size
                height: 80,
                child: Lottie.asset('assets/animations/doctor_animation.json'),
              ),
            ),
          ],
        ),
      ),

      /// ✅ Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Booking'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

/// ✅ `_categoryIcon` Function
Widget _categoryIcon(IconData icon, String title, BuildContext context, Widget page) {
  return GestureDetector(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => page));
    },
    child: Column(children: [
      CircleAvatar(radius: 24, backgroundColor: Colors.blue.shade100, child: Icon(icon, color: Colors.blue)),
      const SizedBox(height: 8),
      Text(title, style: const TextStyle(fontSize: 12)),
    ]),
  );
}
