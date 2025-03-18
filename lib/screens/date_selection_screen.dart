import 'package:flutter/material.dart';
import '../models/doctor.dart';
import '../models/dentist.dart';
import 'time_selection_screen.dart';

class DateSelectionScreen extends StatefulWidget {
  final Doctor? doctor;
  final Dentist? dentist;

  const DateSelectionScreen({super.key, this.doctor, this.dentist});

  @override
  _DateSelectionScreenState createState() => _DateSelectionScreenState();
}

class _DateSelectionScreenState extends State<DateSelectionScreen> {
  DateTime selectedDate = DateTime.now();
  int selectedMonthIndex = DateTime.now().month - 1;
  bool isDateSelected = false;

  final List<String> months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.doctor != null
              ? 'Select Date for ${widget.doctor!.name}'
              : 'Select Date for ${widget.dentist!.name}',
        ),
      ),
      body: Column(
        children: [
          // Month Selector
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 12,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedMonthIndex = index;
                      selectedDate = DateTime(DateTime.now().year, index + 1, 1);
                      isDateSelected = false; // Reset date selection
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: selectedMonthIndex == index ? Colors.blue : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      months[index],
                      style: TextStyle(
                        color: selectedMonthIndex == index ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Date Selector
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.3,
              ),
              itemCount: _getDaysInMonth(selectedMonthIndex + 1),
              itemBuilder: (context, index) {
                DateTime date = DateTime(DateTime.now().year, selectedMonthIndex + 1, index + 1);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDate = date;
                      isDateSelected = true;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isDateSelected && selectedDate.day == date.day ? Colors.blue : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${date.day}',
                      style: TextStyle(
                        color: isDateSelected && selectedDate.day == date.day ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Next Button
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: isDateSelected
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TimeSelectionScreen(
                            selectedDate: selectedDate,
                            doctor: widget.doctor,
                            dentist: widget.dentist,
                          ),
                        ),
                      );
                    }
                  : null,
              child: const Text("Next"),
            ),
          ),
        ],
      ),
    );
  }

  int _getDaysInMonth(int month) {
    return DateTime(DateTime.now().year, month + 1, 0).day;
  }
}
