import 'package:flutter/material.dart';

extension TimeOfDayExtensions on TimeOfDay {
  String toCustomString() {
    final hourString = hour.toString().padLeft(2, '0');
    final minuteString = minute.toString().padLeft(2, '0');
    return '$hourString:$minuteString'; // Converts TimeOfDay to "HH:mm" format
  }
}
