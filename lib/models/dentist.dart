class Dentist {
  final String id;
  final String name;
  final String specialty;
  final String imageUrl;
  final String type;
  final String hospital;
  final String phone;
  final int experience;
  final List<String> treatableDiseases;

  Dentist({
    required this.id,
    required this.name,
    required this.specialty,
    required this.imageUrl,
    required this.type,
    required this.hospital,
    required this.phone,
    required this.experience,
    required this.treatableDiseases,
  });

  // ✅ Factory constructor to create an object from JSON
  factory Dentist.fromJson(Map<String, dynamic> json) {
    return Dentist(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      specialty: json['specialty'] ?? "",
      imageUrl: json['imageUrl'] ?? "",
      type: json['type'] ?? "General Dentist",
      hospital: json['hospital'] ?? "Not Available",
      phone: json['phone'] ?? "No Contact Info",
      experience: json['experience'] ?? 0,
      treatableDiseases: (json['treatableDiseases'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  String? get location => null;

  String? get category => null;

  // ✅ Converts object to JSON format
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'imageUrl': imageUrl,
      'type': type,
      'hospital': hospital,
      'phone': phone,
      'experience': experience,
      'treatableDiseases': treatableDiseases,
    };
  }
}
