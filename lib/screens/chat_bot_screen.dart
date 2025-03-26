import 'package:flutter/material.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];

  /// ✅ **Predefined Medical Responses**
  final Map<String, String> _diseaseResponses = {
    "fever": "For fever, take **Paracetamol (500mg)** every 6 hours and drink plenty of fluids. Rest is important.",
    "headache": "For headache, take **Ibuprofen (400mg)** and avoid screen time.",
    "cold": "For cold, take **Cetirizine (10mg)** at night. Drink warm water.",
    "cough": "For cough, use **Benadryl syrup (10ml)** twice daily.",
    "stomach pain": "For stomach pain, take **Pantoprazole (40mg)** before meals.",
    "diabetes": "For diabetes, maintain a balanced diet and monitor blood sugar levels regularly.",
  };

  /// ✅ **Function to Handle Message Sending**
  void _sendMessage() {
    String userMessage = _messageController.text.trim().toLowerCase();
    if (userMessage.isEmpty) return;

    setState(() {
      // Add user message
      _messages.add({"sender": "user", "text": _messageController.text});
      _messageController.clear();

      // Find response for the message
      String response = "❌ Sorry, I don't have information on that.";
      for (String key in _diseaseResponses.keys) {
        if (userMessage.contains(key)) {
          response = _diseaseResponses[key]!;
          break;
        }
      }

      // Add bot response with a delay (mimic real-time response)
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _messages.add({"sender": "bot", "text": response});
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ChatBot")),
      body: Column(
        children: [
          /// ✅ **Chat Message Display**
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                bool isUser = message["sender"] == "user";

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue[200] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      message["text"]!,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),

          /// ✅ **Message Input Field**
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
