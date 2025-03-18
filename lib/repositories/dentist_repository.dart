import 'dart:convert';
import 'package:doctor_booking/shared/widgets/models/dentist.dart';
import 'package:flutter/services.dart';
import '../models/dentist.dart';

class DentistRepository {
  Future<List<Dentist>> loadDentists() async {
    // Load JSON file from assets
    final String response = await rootBundle.loadString('assets/data/dentists.json');
    final List<dynamic> data = json.decode(response);
    
    return data.map((json) => Dentist.fromJson(json)).toList();
  }
}
