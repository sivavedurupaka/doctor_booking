import 'package:flutter/material.dart';
import '../models/doctor.dart';
import '../models/dentist.dart';
import 'email_entry_screen.dart'; // Navigate to email input screen

class TimeSelectionScreen extends StatefulWidget {
  final DateTime selectedDate;
  final Doctor? doctor;
  final Dentist? dentist;

  const TimeSelectionScreen({
    super.key,
    required this.selectedDate,
    this.doctor,
    this.dentist,
  });

  @override
  _TimeSelectionScreenState createState() => _TimeSelectionScreenState();
}

class _TimeSelectionScreenState extends State<TimeSelectionScreen> {
  String? selectedTime;

  final List<String> availableTimes = [
    "09:00 AM", "10:00 AM", "11:00 AM", "02:00 PM", "03:00 PM", "04:00 PM"
  ];

  @override
  Widget build(BuildContext context) {
    String doctorName = widget.doctor?.name ?? widget.dentist?.name ?? "Doctor";
    String doctorId = widget.doctor?.id ?? widget.dentist?.id ?? "Unknown";

    return Scaffold(
      appBar: AppBar(
        title: Text("Select Time for $doctorName"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            "Available Slots on ${widget.selectedDate.toLocal().toString().split(' ')[0]}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // Time Slot Selection
          Expanded(
            child: ListView.builder(
              itemCount: availableTimes.length,
              itemBuilder: (context, index) {
                String time = availableTimes[index];
                return ListTile(
                  title: Text(time),
                  leading: Radio<String>(
                    value: time,
                    groupValue: selectedTime,
                    onChanged: (value) {
                      setState(() {
                        selectedTime = value;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          // Next Button (Goes to Email Entry Page)
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: selectedTime != null
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EmailEntryScreen(
                            doctorId: doctorId,
                            doctorName: doctorName,
                            selectedDate: widget.selectedDate,
                            selectedTimeSlot: selectedTime!,
                          ),
                        ),
                      );
                    }
                  : null, // Button disabled until time is selected
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text("Next"),
            ),
          ),
        ],
      ),
    );
  }
}
