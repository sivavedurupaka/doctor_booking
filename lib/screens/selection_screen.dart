import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'admin_login_screen.dart';
import 'login_screen.dart';

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( // ✅ Ensures everything is centered
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// ✅ Lottie Animation (Perfectly Centered)
            Lottie.asset(
              "assets/animations/selection.json", // 🔥 Use your animation file
              width: 250, // ✅ Adjust size for better positioning
              height: 250,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 30), // Space between animation and buttons

            /// ✅ Admin Button
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminLoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button color
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Admin",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),

            const SizedBox(height: 20), // Space between buttons

            /// ✅ User Button
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Button color
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "User",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
