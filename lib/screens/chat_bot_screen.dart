import 'package:flutter/material.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];

  final Map<String, String> _diseaseResponses = {
    "fever": "Take Paracetamol 500mg. Rest and stay hydrated.",
    "headache": "Use Ibuprofen 400mg. Avoid screen time.",
    "cold": "Take Cetirizine 10mg at night. Drink warm water.",
    "cough": "Use Benadryl syrup 10ml twice daily.",
  };

  void _sendMessage() {
    String userMessage = _messageController.text.trim().toLowerCase();
    if (userMessage.isEmpty) return;

    setState(() {
      _messages.add({"sender": "user", "text": _messageController.text});
      _messageController.clear();

      String response = "Sorry, I don't have information on that.";
      for (String key in _diseaseResponses.keys) {
        if (userMessage.contains(key)) {
          response = _diseaseResponses[key]!;
          break;
        }
      }

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
          Expanded(child: ListView()),
          TextField(controller: _messageController),
          ElevatedButton(onPressed: _sendMessage, child: const Text("Send"))
        ],
      ),
    );
  }
}
