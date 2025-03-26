import 'package:flutter/material.dart';

class DoctorWorkingHours {
  final String dayOfWeek;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  DoctorWorkingHours({
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });
}
