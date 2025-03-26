// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'login_screen.dart';

// class SignupScreen extends StatefulWidget {
//   const SignupScreen({super.key});

//   @override
//   _SignupScreenState createState() => _SignupScreenState();
// }

// class _SignupScreenState extends State<SignupScreen> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   bool isLoading = false;

//   void showMessage(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
//   }

//   Future<void> _signup() async {
//     String name = nameController.text.trim();
//     String email = emailController.text.trim();
//     String password = passwordController.text.trim();

//     if (name.isEmpty || email.isEmpty || password.isEmpty) {
//       showMessage("Please fill all fields.");
//       return;
//     }

//     setState(() => isLoading = true);

//     try {
//       UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       User? user = userCredential.user;
//       if (user != null) {
//         await user.updateDisplayName(name);

//         // ✅ Ensure user data is stored in Firestore correctly
//         await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
//           'uid': user.uid,
//           'fullName': name, // Changed from 'name' to 'fullName'
//           'email': email,
//           'createdAt': FieldValue.serverTimestamp(),
//         });

//         // ✅ Store user info in SharedPreferences
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('fullName', name);
//         await prefs.setBool('isLoggedIn', true);

//         if (mounted) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const LoginScreen()),
//           );
//         }
//       }
//     } on FirebaseAuthException catch (e) {
//       showMessage(e.message ?? "Signup failed!");
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
//             const Text("Sign Up", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 20),
//             TextField(
//               controller: nameController,
//               decoration: const InputDecoration(labelText: "Full Name", border: OutlineInputBorder()),
//             ),
//             const SizedBox(height: 10),
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
//               onPressed: isLoading ? null : _signup,
//               style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
//               child: isLoading ? const CircularProgressIndicator() : const Text("Sign Up"),
//             ),
//             const SizedBox(height: 10),
//             TextButton(
//               onPressed: () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => const LoginScreen()),
//                 );
//               },
//               child: const Text("Already have an account? Login"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
