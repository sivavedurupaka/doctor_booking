import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// ✅ **Sign In with Email & Password**
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('❌ Login Error: $e');
      return null;
    }
  }

  /// ✅ **Sign Up with Email & Password**
  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('❌ Signup Error: $e');
      return null;
    }
  }

  /// ✅ **Send OTP to Phone Number**
  Future<void> sendOTP(String phoneNumber, Function(String, int?) onCodeSent) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print("❌ OTP Verification Failed: ${e.message}");
      },
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId, resendToken);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  /// ✅ **Verify OTP and Log in User**
  Future<void> verifyOTP(String verificationId, String smsCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    await _auth.signInWithCredential(credential);
  }

  /// ✅ **Get Current User Email**
  String? getUserEmail() {
    return _auth.currentUser?.email;
  }

  /// ✅ **Get Current User Phone Number**
  String? getUserPhoneNumber() {
    return _auth.currentUser?.phoneNumber;
  }

  /// ✅ **Sign Out User**
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
