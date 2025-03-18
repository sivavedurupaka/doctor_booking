import 'package:doctor_booking/shared/widgets/models/dentist.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/doctor.dart';
import '../models/dentist.dart';
import 'home_screen.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final Doctor? doctor;
  final Dentist? dentist;
  final DateTime selectedDate;
  final String selectedTime;

  const BookingConfirmationScreen({
    super.key,
    this.doctor,
    this.dentist,
    required this.selectedDate,
    required this.selectedTime,
  });

  @override
  _BookingConfirmationScreenState createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  @override
  void initState() {
    super.initState();
    saveBooking(); // ✅ Save booking to Firestore

    // ✅ Redirect to Home Page after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      }
    });
  }

  /// ✅ Save Booking to Firestore
  Future<void> saveBooking() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return; // Ensure user is logged in

    try {
      await FirebaseFirestore.instance.collection('bookings').add({
        'userId': user.uid,
        'doctorName': widget.doctor?.name ?? widget.dentist?.name ?? "Unknown",
        'doctorType': widget.doctor != null ? "Doctor" : "Dentist",
        'date': widget.selectedDate.toIso8601String().split('T')[0], // ✅ Format Date
        'timeSlot': widget.selectedTime,
        'createdAt': FieldValue.serverTimestamp(), // ✅ Store Timestamp
      });

      print("✅ Booking saved successfully!");
    } catch (e) {
      print("❌ Error saving booking: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            const Text(
              "Booking Confirmed!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              widget.doctor?.name ?? widget.dentist?.name ?? "Unknown Doctor",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "Date: ${widget.selectedDate.toIso8601String().split('T')[0]}",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Time: ${widget.selectedTime}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
            const SizedBox(height: 10),
            const Text("Redirecting to Home Page..."),
          ],
        ),
      ),
    );
  }
}
