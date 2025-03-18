class Dentist {
  final String id;
  final String name;
  final String specialty;
  final String imageUrl;

  Dentist({
    required this.id,
    required this.name,
    required this.specialty,
    required this.imageUrl,
  });

  factory Dentist.fromJson(Map<String, dynamic> json) {
    return Dentist(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      specialty: json['specialty'] ?? "",
      imageUrl: json['imageUrl'] ?? "",
    );
  }
}

