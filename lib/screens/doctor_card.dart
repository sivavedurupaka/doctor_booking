// import 'package:flutter/material.dart';
// import '../models/doctor.dart';

// class DoctorCard extends StatelessWidget {
//   final Doctor doctor;
//   final VoidCallback onBookNow;
//   final VoidCallback onChat;

//   const DoctorCard({
//     super.key,
//     required this.doctor,
//     required this.onBookNow,
//     required this.onChat,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// ✅ Doctor Name
//             Text(
//               doctor.name,
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 4),

//             /// ✅ Specialty and Location
//             Text(
//               "${doctor.specialty} • ${doctor.location}",
//               style: const TextStyle(fontSize: 16, color: Colors.grey),
//             ),
//             const SizedBox(height: 12),

//             /// ✅ Book Now & Chat Buttons (Stacked Below Each Other)
//             SizedBox(
//               width: double.infinity, // ✅ Ensures both buttons take full width
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   ElevatedButton(
//                     onPressed: onBookNow,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                     ),
//                     child: const Text("Book Now"),
//                   ),
//                   const SizedBox(height: 8), // Space between buttons
//                   ElevatedButton(
//                     onPressed: onChat,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                     ),
//                     child: const Text("Chat"),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
