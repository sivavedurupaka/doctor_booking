import 'package:flutter/material.dart';
import 'email_input_screen.dart'; // Navigate to Email Input Screen

class BookAppointmentScreen extends StatefulWidget {
  final String doctorId;
  final String doctorName;

  const BookAppointmentScreen({
    super.key,
    required this.doctorId,
    required this.doctorName,
  });

  @override
  _BookAppointmentScreenState createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  DateTime? selectedDate;
  String? selectedTimeSlot;

  /// ✅ Available Time Slots
  final List<String> timeSlots = [
    "09:00 AM - 10:00 AM",
    "10:00 AM - 11:00 AM",
    "11:00 AM - 12:00 PM",
    "02:00 PM - 03:00 PM",
    "03:00 PM - 04:00 PM",
    "04:00 PM - 05:00 PM",
  ];

  /// ✅ Pick Date Function
  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  /// ✅ Proceed to Enter Email
  void _proceedToEmailInput() {
    if (selectedDate == null || selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("⚠️ Please select both date and time slot!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    /// ✅ Navigate to Email Input Screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmailInputScreen(
          doctorId: widget.doctorId,
          doctorName: widget.doctorName,
          selectedDate: selectedDate!,
          selectedTimeSlot: selectedTimeSlot!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Book Appointment")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ✅ Doctor Name
            Text(
              "Doctor: ${widget.doctorName}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            /// ✅ Date Picker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate == null
                      ? "📅 Select Date"
                      : "📅 ${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
                  style: const TextStyle(fontSize: 16),
                ),
                ElevatedButton(
                  onPressed: _selectDate,
                  child: const Text("Pick Date"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// ✅ Time Slot Selection
            const Text("⏰ Select Time Slot:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: timeSlots.map((time) {
                return ChoiceChip(
                  label: Text(time),
                  selected: selectedTimeSlot == time,
                  selectedColor: Colors.blue.shade200,
                  onSelected: (selected) {
                    setState(() {
                      selectedTimeSlot = time;
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            /// ✅ Proceed Button
            Center(
              child: ElevatedButton(
                onPressed: _proceedToEmailInput,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text("Next ➡️"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
