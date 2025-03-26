// import 'package:doctor_booking/screens/Firebase/signup_screen.dart';
// import 'package:doctor_booking/screens/home_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   bool isLoading = false;

//   Future<void> _login() async {
//     setState(() => isLoading = true);

//     try {
//       UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: emailController.text.trim(),
//         password: passwordController.text.trim(),
//       );

//       User? user = userCredential.user;
//       if (user != null) {
//         // ✅ Fetch user's full name from Firestore
//         DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
//         String firstName = userDoc['fullName'] ?? 'User'; // Changed to 'fullName'

//         // ✅ Store user info in SharedPreferences
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('fullName', firstName);
//         await prefs.setBool('isLoggedIn', true);

//         if (mounted) {
//           Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(builder: (context) => const HomeScreen()),
//             (route) => false,
//           );
//         }
//       }
//     } on FirebaseAuthException catch (e) {
//       String errorMessage = e.message ?? "Login failed!";
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
//       }
//     }

//     setState(() => isLoading = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text("Login", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 20),
//             TextField(
//               controller: emailController,
//               decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: passwordController,
//               obscureText: true,
//               decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder()),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: isLoading ? null : _login,
//               style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
//               child: isLoading ? const CircularProgressIndicator() : const Text("Login"),
//             ),
//             const SizedBox(height: 10),
//             TextButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const SignupScreen()),
//                 );
//               },
//               child: const Text("Don't have an account? Sign Up"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
