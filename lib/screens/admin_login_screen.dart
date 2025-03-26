import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  _AdminLoginScreenState createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void _adminLogin() async {
    setState(() => isLoading = true);

    // ✅ Hardcoded admin credentials (You can replace with Firebase)
    const String adminPhone = "9182357305";
    const String adminPassword = "admin123";

    if (phoneController.text == adminPhone && passwordController.text == adminPassword) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setBool('isAdmin', true);

      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid admin credentials!")));
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// ✅ Background Image
      body: Stack(
        fit: StackFit.expand,
        children: [
          /// 📌 Background Image
          Image.asset(
            "assets/images/admin_bg.jpg", // 🔥 Update with your image path
            fit: BoxFit.cover,
          ),

          /// 📌 Overlay for Better Visibility
          Container(
            color: Colors.black.withOpacity(0.5), // Dark overlay effect
          ),

          /// 📌 Login Form
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// ✅ Admin Title
                  const Text(
                    "Admin Login",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // White color for visibility
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// ✅ Phone Number Input
                  TextField(
                    controller: phoneController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      labelStyle: const TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// ✅ Password Input
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: const TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// ✅ Login Button
                  ElevatedButton(
                    onPressed: isLoading ? null : _adminLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            "Login",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
