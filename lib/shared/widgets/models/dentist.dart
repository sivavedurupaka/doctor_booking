// class Dentist {
//   final String name;
//   final String specialty;
//   final String imageUrl;
//   final String location;
//   final double rating;
//   final int experience;
//   final int patientCount;
//   final String bio;

//   Dentist({
//     required this.name,
//     required this.specialty,
//     required this.imageUrl,
//     required this.location,
//     required this.rating,
//     required this.experience,
//     required this.patientCount,
//     required this.bio,
//   });

//   // Convert JSON to Dentist Object
//   factory Dentist.fromJson(Map<String, dynamic> json) {
//     return Dentist(
//       name: json['name'],
//       specialty: json['specialty'],
//       imageUrl: json['imageUrl'],
//       location: json['location'],
//       rating: (json['rating'] as num).toDouble(),
//       experience: json['experience'],
//       patientCount: json['patientCount'],
//       bio: json['bio'],
//     );
//   }

//   String? get specialization => null;

//   get type => null;

//   get profileImageUrl => null;

//   // Convert Dentist Object to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'specialty': specialty,
//       'imageUrl': imageUrl,
//       'location': location,
//       'rating': rating,
//       'experience': experience,
//       'patientCount': patientCount,
//       'bio': bio,
//     };
//   }
// }
