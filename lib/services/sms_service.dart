import 'dart:convert';
import 'package:http/http.dart' as http;

class SmsService {
  static const String _apiKey = "AXVtOTNcsluJYUMWn9Lr40bKdaRgfho3Bzk7CQ8GxFiSqZpmI2782poeMHwtCPcNlAXOqiUWQu5Y9v6m"; // 🔥 Replace with your API Key
  static const String _senderId = "FSTSMS"; // Default sender ID

  /// ✅ Function to send SMS
  static Future<void> sendBookingConfirmation({
    required String phoneNumber,
    required String doctorName,
    required String date,
    required String timeSlot,
  }) async {
    final String message =
        "Your appointment is booked with Dr. $doctorName on $date at $timeSlot. Thank you!";

    final Uri url = Uri.parse("https://www.fast2sms.com/dev/bulkV2");

    final response = await http.post(
      url,
      headers: {
        "authorization": _apiKey,
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "route": "q", // Fast2SMS Quick Send Route
        "message": message,
        "language": "english",
        "flash": "0",
        "numbers": phoneNumber,
      }),
    );

    if (response.statusCode == 200) {
      print("✅ SMS Sent Successfully");
    } else {
      print("❌ SMS Sending Failed: ${response.body}");
    }
  }
}
