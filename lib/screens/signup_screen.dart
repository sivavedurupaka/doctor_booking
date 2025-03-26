import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart'; // ✅ Ensure login screen is imported

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  /// ✅ **Show SnackBar Message**
  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  /// ✅ **Signup Function (Redirects to Login After Success)**
  Future<void> _signup() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      showMessage("⚠ Please fill all fields.");
      return;
    }

    setState(() => isLoading = true);
    print("⚡ Signup process started...");

    try {
      // ✅ Create New User in Firebase Auth
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

      print("✅ User created successfully!");

      // ✅ Store User Data in Firestore
      await FirebaseFirestore.instance.collection('users').doc(email).set({
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      print("✅ User data saved in Firestore!");

      // ✅ Redirect to Login Screen After Signup
      if (mounted) {
        print("🚀 Redirecting to Login Screen...");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }

    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          print("⚠ Email already exists. Redirecting to login...");
          showMessage("⚠ Email already registered. Please log in.");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        } else {
          showMessage("⚠ Error: ${e.message}");
        }
      }
    }

    setState(() => isLoading = false);
  }

  /// ✅ **Reset Password Function**
  Future<void> _resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showMessage("📩 Password reset email sent! Check your inbox.");
    } catch (e) {
      showMessage("⚠ Error sending reset email: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Sign Up", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Full Name")),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: passwordController, obscureText: true, decoration: const InputDecoration(labelText: "Password")),
            const SizedBox(height: 20),
            
            /// ✅ **Signup Button**
            ElevatedButton(
              onPressed: isLoading ? null : _signup,
              child: isLoading ? const CircularProgressIndicator() : const Text("Sign Up"),
            ),
            
            /// ✅ **Go to Login**
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
              },
              child: const Text("Already have an account? Login"),
            ),

            /// ✅ **Forgot Password**
            TextButton(
              onPressed: () {
                if (emailController.text.isNotEmpty) {
                  _resetPassword(emailController.text.trim());
                } else {
                  showMessage("⚠ Enter your email first.");
                }
              },
              child: const Text("Forgot Password?"),
            ),
          ],
        ),
      ),
    );
  }
}
