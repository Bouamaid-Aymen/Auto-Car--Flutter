import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:my_app_car/screens/ChatBot/consts.dart';

class ChatBot extends StatefulWidget {
  final _openAI = OpenAI.instance.build(
      token: openAI_API_KEY,
      baseOption: HttpSetup(
        receiveTimeout: const Duration(seconds: 5),
      ),
      enableLog: true);
  final ChatUser _currentUser =
      ChatUser(id: '1', firstName: "aymen", lastName: "bouamaid");

  final ChatUser _gptchatUser =
      ChatUser(id: '2', firstName: "chat", lastName: "gpt");

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  List<ChatMessage> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Chat Bot"),
      ),
      body: Container(
      color: Colors.white, // Set the background color to white
      child: DashChat(
        currentUser: widget._currentUser,
        messageOptions: const MessageOptions(
          currentUserContainerColor: Colors.blue,
          textColor: Colors.white,
        ),
        onSend: (ChatMessage m) {
          getChatResponse(m);
        },
        messages: _messages,
      ),
    ),
  );
  }

  Future<void> getChatResponse(ChatMessage m) async {
    try {
      setState(() {
        _messages.insert(0, m);
      });
      
      List<Messages> _messagesHistory = _messages.reversed.map((m) {
        if (m.user == widget._currentUser) {
          return Messages(role: Role.user, content: m.text,);
        } else {
          return Messages(role: Role.assistant, content: m.text);
        }
      }).toList();
      
      final request = ChatCompleteText(
          model: GptTurbo0301ChatModel(),
          messages: _messagesHistory,
          maxToken: 200);
      
      final response = await widget._openAI.onChatCompletion(request: request);
      
      for (var element in response!.choices) {
        if (element.message != null) {
          setState(() {
            _messages.insert(
              0,
              ChatMessage(
                  user: widget._gptchatUser,
                  createdAt: DateTime.now(),
                  text: element.message!.content),
            );
          });
        }
      }
    } catch (e) {
      print('Erreur de requête : $e');

    }
  }
}
