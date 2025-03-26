import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart'; // ✅ Added Forgot Password Screen

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  /// ✅ Login Function
  Future<void> _login() async {
    setState(() => isLoading = true);
    print("⚡ Login started...");

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      print("✅ User authenticated!");

      User? user = userCredential.user;
      if (user != null) {
        print("🔍 Fetching user data from Firestore...");

        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (!userDoc.exists) {
          print("❌ No user document found in Firestore!");
          showMessage("User data not found. Try signing up again.");
          setState(() => isLoading = false);
          return;
        }

        var data = userDoc.data() as Map<String, dynamic>?;  
        String firstName = data?['name'] ?? "User";  
        print("✅ User found: $firstName");

        // ✅ Save login state properly
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('firstName', firstName);
        await prefs.setBool('isLoggedIn', true);
        print("✅ Login status saved in SharedPreferences");

        if (mounted) {
          print("🚀 Navigating to HomeScreen...");
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      print("❌ FirebaseAuthException: ${e.message}");
      showMessage(e.message ?? "Login failed!");
    } catch (e) {
      print("❌ Unexpected error: $e");
      showMessage("An unexpected error occurred: $e");
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  /// ✅ Show SnackBar Message
  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// ✅ Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/login_bg.jpg"), // 🔹 Replace with your image
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// ✅ Login Form with Transparent Background
          Center(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8), // 🔹 Semi-transparent background
                borderRadius: BorderRadius.circular(15),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Login", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),

                  /// ✅ Email Input
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 10),

                  /// ✅ Password Input
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder()),
                  ),

                  /// ✅ Forgot Password Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()));
                      },
                      child: const Text("Forgot Password?", style: TextStyle(color: Colors.blue)),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// ✅ Login Button
                  ElevatedButton(
                    onPressed: isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                    child: isLoading ? const CircularProgressIndicator() : const Text("Login"),
                  ),

                  const SizedBox(height: 10),

                  /// ✅ Sign Up Button
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const SignupScreen()),
                      );
                    },
                    child: const Text("Don't have an account? Sign Up"),
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
