import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/doctor.dart';

class ChatScreen extends StatefulWidget {
  final Doctor? doctor;
  final String doctorName;
  final String? specialty; // ✅ Made optional
  final List<String>? treatableDiseases; // ✅ Made optional

  const ChatScreen({
    super.key,
    this.doctor,
    required this.doctorName,
    this.specialty, // ✅ Removed `required`
    this.treatableDiseases, // ✅ Removed `required`
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, String>> messages = [];
  Map<String, String> _diseaseResponses = {};

  @override
  void initState() {
    super.initState();
    loadResponses();
  }

  // ✅ Load chatbot responses from `diseases.json`
  Future<void> loadResponses() async {
    try {
      String jsonString = await rootBundle.loadString('assets/data/diseases.json'); // 🔥 Using diseases.json
      Map<String, dynamic> jsonData = json.decode(jsonString);
      setState(() {
        _diseaseResponses = jsonData.map((key, value) => MapEntry(key.toLowerCase(), value.toString()));
      });
    } catch (e) {
      print("Error loading diseases.json: $e");
    }
  }

  // ✅ Send user message and generate auto-reply
  void sendMessage() {
    String userMessage = _messageController.text.trim().toLowerCase();
    if (userMessage.isEmpty) return;

    setState(() {
      messages.add({"sender": "user", "text": _messageController.text});
      _messageController.clear();
    });

    // ✅ Check JSON for response
    String response = "Sorry, I don't have information on that.";
    for (String key in _diseaseResponses.keys) {
      if (userMessage.contains(key)) {
        response = _diseaseResponses[key]!;
        break;
      }
    }

    // ✅ Add bot response after delay
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        messages.add({"sender": "doctor", "text": response});
        _scrollToBottom();
      });
    });
  }

  // ✅ Scroll to latest message
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with ${widget.doctor?.name ?? "General Doctor"}"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                bool isUser = messages[index]["sender"] == "user";
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue[300] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      messages[index]["text"]!,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "Type your message...",
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) => sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
