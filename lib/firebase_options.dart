import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    } else {
      return android; // For Android
    }
  }

  // Web Firebase configuration
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyC6dMPB6uvJbXeEfjMhDa6lSJr5xBgF6qc",
    authDomain: "doctor-appointment-7e03b.firebaseapp.com",
    projectId: "doctor-appointment-7e03b",
    storageBucket: "doctor-appointment-7e03b.appspot.com",
    messagingSenderId: "352409724927",
    appId: "1:352409724927:android:fd6a7c2b95a0811ecb69ca",
    measurementId: "G-R6QM9HWFP4",
  );

  // Android Firebase configuration
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyC6dMPB6uvJbXeEfjMhDa6lSJr5xBgF6qc",
    authDomain: "doctor-appointment-7e03b.firebaseapp.com",
    projectId: "doctor-appointment-7e03b",
    storageBucket: "doctor-appointment-7e03b.appspot.com",
    messagingSenderId: "352409724927",
    appId: "1:352409724927:android:fd6a7c2b95a0811ecb69ca",
    measurementId: "G-R6QM9HWFP4",  // Put the correct Measurement ID here if needed
  );
}



// import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

// class DefaultFirebaseOptions {
//   static FirebaseOptions get currentPlatform {
//     return FirebaseOptions(
//       apiKey: "AIzaSyDZx-YgoFDObwVMlUuM8Fhy_KDZ5bNaUK0",
//       authDomain: "YOUR_AUTH_DOMAIN",
//       projectId: "doctor-booking-f626b",
//       messagingSenderId: "454252268880",
//       appId: "1:454252268880:android:0a0f045ba2219a27ca7055",
//     );
//   }
// }
