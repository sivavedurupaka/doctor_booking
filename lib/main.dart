import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'screens/selection_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// ✅ Ensure Firebase is initialized correctly
  await initializeFirebase();

  runApp(const MyApp());
}

/// ✅ **Function to Initialize Firebase (Fixes Duplicate Error)**
Future<void> initializeFirebase() async {
  try {
    if (Firebase.apps.isNotEmpty) {
      print("⚠️ Firebase is already initialized, skipping...");
      return; // Prevent duplicate initialization
    }
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    print("✅ Firebase initialized successfully!");
  } catch (e) {
    print("❌ Firebase initialization failed: $e");
  }
}

/// ✅ **Main App Widget**
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Doctor Booking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const AuthCheckScreen(), // ✅ Start with Splash and Auth Check
    );
  }
}

/// ✅ **Authentication Check Screen**
class AuthCheckScreen extends StatefulWidget {
  const AuthCheckScreen({super.key});

  @override
  _AuthCheckScreenState createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  @override
  void initState() {
    super.initState();
    navigateAfterSplash();
  }

  /// ✅ **Navigate After Splash**
  Future<void> navigateAfterSplash() async {
    await Future.delayed(const Duration(seconds: 2)); // Show Splash for 2 seconds
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SelectionScreen()), // ✅ Always go to SelectionScreen
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen(); // ✅ Always show Splash first
  }
}
