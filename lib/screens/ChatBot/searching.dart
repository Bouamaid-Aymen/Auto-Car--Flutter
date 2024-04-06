import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class ChatbotCar extends StatefulWidget {
  const ChatbotCar({super.key});

  @override
  State<ChatbotCar> createState() => _ChatbotCar();
}

class _ChatbotCar extends State<ChatbotCar> {
  final Gemini gemini = Gemini.instance;

  List<ChatMessage> messages = [];
  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  ChatUser geminiUser = ChatUser(id: "1", firstName: "Assistant");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Auto ',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Car',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Container(
  decoration: BoxDecoration(
    color: Colors.blueGrey, // Changer en vert
    
  ),
  child: _buildUI(),
),

    );
  }

  Widget _buildUI() {
    return DashChat(
        currentUser: currentUser, onSend: _sendMessage, messages: messages);
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });

    try {
      String question = chatMessage.text;
      gemini.streamGenerateContent(question).listen((event) {
        ChatMessage? lastMessage = messages.firstOrNull;
        if (lastMessage != null && lastMessage.user == geminiUser) {
          lastMessage = messages.removeAt(0);
          String response = event.content!.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              "";
          lastMessage.text += response;
          setState(() {
            messages = [lastMessage!, ...messages];
          });
        } else {
          String response = event.content!.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              "";
          ChatMessage message = ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: response,
          );
          setState(() {
            messages = [message, ...messages];
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }
}
