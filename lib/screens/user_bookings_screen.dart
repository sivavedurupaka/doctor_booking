import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserBookingsScreen extends StatefulWidget {
  const UserBookingsScreen({super.key});

  @override
  _UserBookingsScreenState createState() => _UserBookingsScreenState();
}

class _UserBookingsScreenState extends State<UserBookingsScreen> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Bookings")),
      body: user == null
          ? const Center(child: Text("Please log in to see your bookings."))
          : RefreshIndicator(
              onRefresh: _refreshBookings,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('bookings')
                    .where('userId', isEqualTo: user?.uid ?? '')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    print("❌ No bookings found for user: ${user?.uid}");
                    return const Center(child: Text("No bookings found."));
                  }

                  print("✅ Bookings found: ${snapshot.data!.docs.length}");

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var bookingData =
                          snapshot.data!.docs[index].data() as Map<String, dynamic>?;

                      if (bookingData == null) return const SizedBox(); // Prevent errors

                      print("📝 Booking Data: $bookingData"); // Debug Print

                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: const Icon(Icons.medical_services, color: Colors.blue),
                          title: Text(
                            bookingData['doctorName'] ?? 'Unknown Doctor',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "📅 Date: ${bookingData['date'] ?? 'N/A'} | 🕒 Time: ${bookingData['timeSlot'] ?? 'N/A'}",
                            style: const TextStyle(color: Colors.black54),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmDelete(snapshot.data!.docs[index].id),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }

  /// 🔄 Refresh Bookings
  Future<void> _refreshBookings() async {
    setState(() {}); // Reloads the screen
  }

  /// ❌ Show Confirmation Before Deleting Booking
  Future<void> _confirmDelete(String bookingId) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Cancel Booking?"),
          content: const Text("Are you sure you want to cancel this booking?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteBooking(bookingId);
              },
              child: const Text("Yes", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  /// ✅ Delete Booking from Firestore
  Future<void> _deleteBooking(String bookingId) async {
    try {
      await FirebaseFirestore.instance.collection('bookings').doc(bookingId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Booking cancelled.")),
      );
      setState(() {}); // Refresh UI
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }
}
