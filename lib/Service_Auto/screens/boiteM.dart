import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:my_app_car/screens/Car_list.dart';

class Message {
  final String message;
  final String usernameU;
  final String email;
  final String nomService;

  Message({
    required this.message,
    required this.usernameU,
    required this.email,
    required this.nomService,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'],
      usernameU: json['usernameU'],
      email: json['email'], 
      nomService: json['nom_service'],
    );
  }
}

class MessageListPage extends StatefulWidget {
  @override
  _MessageListPageState createState() => _MessageListPageState();
}

class _MessageListPageState extends State<MessageListPage> {
  TextEditingController messageController = TextEditingController();
  late Future<List<Message>> futureMessages;
  List<dynamic> services = [];

  @override
  void initState() {
    super.initState();
    futureMessages = fetchMessages();
  }

  Future<List<Message>> fetchMessages() async {
    final String email = TokenStorage.getEmail();


    final response =
        await http.get(Uri.parse('http://localhost:3000/users/message'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Message> messages = data
          .where((json) => json['email'].toLowerCase() == email.toLowerCase())
          .map((json) => Message.fromJson(json))
          .toList();
      return messages;
    } else {
      throw Exception('Failed to load messages');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          'Boite de messagerie',
          style: TextStyle(color: Colors.blue),
        )),
      ),
      body: FutureBuilder<List<Message>>(
        future: futureMessages,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else {
            List<Message> messages = snapshot.data!;
            return ListView.builder(
              itemCount: messages.length * 2 - 1,
              itemBuilder: (context, index) {
                if (index.isOdd) {
                  return Divider();
                }
                final messageIndex = index ~/ 2;
                Message message = messages[messageIndex];
                return ListTile(
                  title: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Message en par : ',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                          ),
                        ),
                        TextSpan(
                          text: '${message.usernameU}',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  subtitle: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Message: ',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                          ),
                        ),
                        TextSpan(
                          text: '${message.message}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  tileColor: const Color.fromARGB(141, 158, 158, 158),
                  contentPadding: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }


}
