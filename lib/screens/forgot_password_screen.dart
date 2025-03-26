import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  /// ✅ Reset Password Function
  Future<void> _resetPassword() async {
    setState(() => isLoading = true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
      showMessage("Password reset email sent. Check your inbox.");
    } on FirebaseAuthException catch (e) {
      showMessage(e.message ?? "Error sending reset email.");
    }
    setState(() => isLoading = false);
  }

  /// ✅ Show SnackBar Message
  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Reset Password", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("Enter your email to receive a password reset link."),
            const SizedBox(height: 20),

            /// ✅ Email Input
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),

            /// ✅ Reset Password Button
            ElevatedButton(
              onPressed: isLoading ? null : _resetPassword,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              child: isLoading ? const CircularProgressIndicator() : const Text("Send Reset Link"),
            ),

            const SizedBox(height: 10),

            /// ✅ Back to Login Button
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Back to Login"),
            ),
          ],
        ),
      ),
    );
  }
}
