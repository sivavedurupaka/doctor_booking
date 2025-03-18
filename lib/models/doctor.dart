class Doctor {
  final String id;
  final String name;
  final String specialty;
  final String location;
  final String profileImageUrl;
  final String category;
  final String hospital;
  final String contact;
  final String experience;
  final double rating;
  final List<String> treatableDiseases; // ✅ Treatable diseases added

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.location,
    required this.profileImageUrl,
    required this.category,
    required this.hospital,
    required this.contact,
    required this.experience,
    required this.rating,
    required this.treatableDiseases, // ✅ Included diseases field
  });

  /// ✅ Sample doctors for testing
  static List<Doctor> sampleDoctors = [
    Doctor(
      id: '1',
      name: 'Vedurupaka Ganesh',
      specialty: 'Blood Test Specialist',
      location: 'Hyderabad',
      profileImageUrl: 'https://example.com/doctor1.jpg',
      category: 'Cardiology',
      hospital: 'Apollo Hospital',
      contact: '+91 9876543210',
      experience: '10 years',
      rating: 4.5,
      treatableDiseases: ['Fever', 'Diabetes', 'Infections'], // ✅ Diseases added
    ),
    Doctor(
      id: '2',
      name: 'Manoj Kumar',
      specialty: 'Heart Specialist',
      location: 'Bangalore',
      profileImageUrl: 'https://example.com/doctor2.jpg',
      category: 'Cardiology',
      hospital: 'Fortis Hospital',
      contact: '+91 8765432109',
      experience: '12 years',
      rating: 4.8,
      treatableDiseases: ['Heart Disease', 'Blood Pressure', 'Chest Pain'], // ✅ Diseases added
    ),
  ];

  /// ✅ Convert JSON to Doctor object
  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      specialty: json['specialty'] ?? '',
      location: json['location'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      category: json['category'] ?? '',
      hospital: json['hospital'] ?? '',
      contact: json['contact'] ?? '',
      experience: json['experience'] ?? '0 years',
      rating: (json['rating'] ?? 0.0).toDouble(),
      treatableDiseases: List<String>.from(json['treatableDiseases'] ?? []), // ✅ Convert JSON list to Dart list
    );
  }

  String? get specialization => null;

  /// ✅ Convert List of JSON objects to List of Doctor objects
  static List<Doctor> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Doctor.fromJson(json)).toList();
  }

  /// ✅ Convert Doctor object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'location': location,
      'profileImageUrl': profileImageUrl,
      'category': category,
      'hospital': hospital,
      'contact': contact,
      'experience': experience,
      'rating': rating,
      'treatableDiseases': treatableDiseases, // ✅ Convert list to JSON
    };
  }
}
