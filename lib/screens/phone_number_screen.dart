import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_screen.dart'; // Import HomeScreen

class PhoneNumberScreen extends StatefulWidget {
  final String doctorId;
  final String doctorName;
  final DateTime selectedDate;
  final String selectedTimeSlot;

  const PhoneNumberScreen({
    super.key,
    required this.doctorId,
    required this.doctorName,
    required this.selectedDate,
    required this.selectedTimeSlot,
  });

  @override
  _PhoneNumberScreenState createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
  bool _isLoading = false;

  /// ✅ Function to Validate Phone Number
  bool _isValidPhoneNumber(String number) {
    return RegExp(r'^[6-9]\d{9}$').hasMatch(number);
  }

  /// ✅ Function to Confirm Booking and Send SMS
  Future<void> _confirmBooking() async {
    String phoneNumber = _phoneController.text.trim();

    if (!_isValidPhoneNumber(phoneNumber)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid 10-digit mobile number")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      /// 🔹 Save Booking in Firestore
      await FirebaseFirestore.instance.collection('bookings').add({
        'userId': user?.uid,
        'userEmail': user?.email,
        'doctorId': widget.doctorId,
        'doctorName': widget.doctorName,
        'date': widget.selectedDate.toIso8601String().substring(0, 10),
        'timeSlot': widget.selectedTimeSlot,
        'phoneNumber': phoneNumber,
        'createdAt': FieldValue.serverTimestamp(),
      });

      /// 🔹 Send SMS Confirmation
      bool smsSent = await _sendSMS(phoneNumber);
      if (smsSent) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Appointment confirmed! SMS sent.")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("⚠️ Appointment booked, but SMS not sent.")),
        );
      }

      /// ✅ Navigate to Home Screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// ✅ Function to Send SMS via Fast2SMS
  Future<bool> _sendSMS(String number) async {
    const String fast2smsApiKey = "AXVtOTNcsluJYUMWn9Lr40bKdaRgfho3Bzk7CQ8GxFiSqZpmI2782poeMHwtCPcNlAXOqiUWQu5Y9v6m"; // 🔴 Store securely

    final String message =
        "Hello! Your appointment with Dr. ${widget.doctorName} is booked for ${widget.selectedDate.toIso8601String().substring(0, 10)} at ${widget.selectedTimeSlot}.";

    final response = await http.post(
      Uri.parse("https://www.fast2sms.com/dev/bulkV2"),
      headers: {
        "authorization": fast2smsApiKey,
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "route": "v3", // ✅ Correct route for sending messages
        "message": message,
        "language": "english",
        "flash": "0",
        "numbers": number
      }),
    );

    if (response.statusCode == 200) {
      print("✅ SMS Sent Successfully: ${response.body}");
      return true;
    } else {
      print("❌ SMS Sending Failed: ${response.body}");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enter Mobile Number")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Mobile Number",
                prefixText: "+91 ",
              ),
              maxLength: 10,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _confirmBooking,
                    child: const Text("Confirm Booking"),
                  ),
          ],
        ),
      ),
    );
  }
}
