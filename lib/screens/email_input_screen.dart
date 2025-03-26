import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_screen.dart';

class EmailInputScreen extends StatefulWidget {
  final String doctorId;
  final String doctorName;
  final DateTime selectedDate;
  final String selectedTimeSlot;

  const EmailInputScreen({
    super.key,
    required this.doctorId,
    required this.doctorName,
    required this.selectedDate,
    required this.selectedTimeSlot,
  });

  @override
  _EmailInputScreenState createState() => _EmailInputScreenState();
}

class _EmailInputScreenState extends State<EmailInputScreen> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  /// ✅ Confirm Appointment & Send Email
  Future<void> _confirmAppointment() async {
    String email = emailController.text.trim();

    if (email.isEmpty || !email.contains("@")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Enter a valid email address!")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // ✅ Save appointment to Firestore
      await FirebaseFirestore.instance.collection('bookings').add({
        'email': email,
        'doctorId': widget.doctorId,
        'doctorName': widget.doctorName,
        'appointmentDate': widget.selectedDate.toIso8601String().split('T')[0],
        'appointmentTime': widget.selectedTimeSlot,
        'createdAt': FieldValue.serverTimestamp(),
      });

      print("✅ Appointment saved in Firestore!");

      // ✅ Send Email with Appointment Details
      bool emailSent = await _sendEmail(email);

      if (emailSent) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Appointment booked & Email Sent!")),
        );

        // ✅ Redirect to Home Page
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("⚠️ Booking successful, but email not sent!")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error: $e")),
      );
    }

    setState(() => isLoading = false);
  }

  /// ✅ Send Email via EmailJS
  Future<bool> _sendEmail(String email) async {
    const String apiUrl = "https://api.emailjs.com/api/v1.0/email/send";
    const String serviceId = "service_z4ukixh"; // 🔹 Replace with your EmailJS Service ID
    const String templateId = "template_9fq4a6q"; // 🔹 Replace with your EmailJS Template ID
    const String publicKey = "AP0R2r2PZ62f-LAaB"; // 🔹 Replace with your EmailJS Public API Key

    final Map<String, dynamic> emailData = {
      "service_id": serviceId,
      "template_id": templateId,
      "user_id": publicKey, // ✅ Updated to correct Public API Key
      "template_params": {
        "to_email": email,
        "doctor_name": widget.doctorName,
        "appointment_date": widget.selectedDate.toIso8601String().split('T')[0],
        "appointment_time": widget.selectedTimeSlot,
      }
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(emailData),
    );

    if (response.statusCode == 200) {
      print("✅ Email Sent Successfully!");
      return true;
    } else {
      print("❌ Email Sending Failed: ${response.body}");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enter Email")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Enter your Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _confirmAppointment,
                    child: const Text("Confirm Appointment"),
                  ),
          ],
        ),
      ),
    );
  }
}
