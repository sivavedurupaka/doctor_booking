import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'selection_screen.dart';
import 'home_screen.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key}); // ✅ Removed unnecessary parameters

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  /// ✅ Check Login Status & Navigate
  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3)); // Splash delay

    if (!mounted) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    bool isAdmin = prefs.getBool('isAdmin') ?? false;

    /// ✅ If logged in → Go to HomeScreen, else → Show SelectionScreen
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SelectionScreen()), // ✅ Goes to Admin/User selection
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset("assets/animations/splash.json", width: 200, height: 200),
      ),
    );
  }
}
