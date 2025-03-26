import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_screen.dart'; // ✅ Import HomeScreen

class EmailEntryScreen extends StatefulWidget {
  final String doctorId;
  final String doctorName;
  final DateTime selectedDate;
  final String selectedTimeSlot;

  const EmailEntryScreen({
    super.key,
    required this.doctorId,
    required this.doctorName,
    required this.selectedDate,
    required this.selectedTimeSlot,
  });

  @override
  _EmailEntryScreenState createState() => _EmailEntryScreenState();
}

class _EmailEntryScreenState extends State<EmailEntryScreen> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  /// ✅ **Function to Send Booking Confirmation Email**
  Future<void> sendBookingConfirmation(String email) async {
    setState(() => isLoading = true);

    try {
      // ✅ **Send Email & Save in Firestore**
      await sendBookingConfirmationEmail(email, widget.doctorName, widget.selectedDate, widget.selectedTimeSlot);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Booking confirmation email stored successfully!")),
      );

      // ✅ **Navigate to HomeScreen After Confirmation**
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      });

    } catch (e) {
      print("❌ Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error: ${e.toString()}")),
      );
    }

    setState(() => isLoading = false);
  }

  /// ✅ **Sends a Booking Confirmation Email & Saves It in Firestore**
  Future<void> sendBookingConfirmationEmail(String email, String doctorName, DateTime date, String timeSlot) async {
    try {
      String formattedDate = "${date.day}-${date.month}-${date.year}";

      String message = """
      Dear Patient,

      Your appointment has been successfully booked.

      🔹 Doctor: $doctorName
      🔹 Date: $formattedDate
      🔹 Time Slot: $timeSlot

      Please reach the hospital on time.

      Regards,  
      Doctor Booking App
      """;

      await FirebaseFirestore.instance.collection('emails').add({
        'to': email,
        'subject': "Appointment Confirmation",
        'body': message,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print("✅ Booking confirmation email stored in Firestore.");
    } catch (e) {
      print("❌ Error sending email: $e");
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enter Your Email")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter your email to confirm your appointment:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Email Address",
              ),
            ),
            const SizedBox(height: 20),

            /// ✅ **Submit Button**
            Center(
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        if (emailController.text.isNotEmpty) {
                          sendBookingConfirmation(emailController.text);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("⚠️ Please enter an email")),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Send Booking Confirmation"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
