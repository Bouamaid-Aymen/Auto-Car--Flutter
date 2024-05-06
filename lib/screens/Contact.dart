import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:my_app_car/screens/Car_list.dart';

class Message {
  final int id;
  final String message;
  final String usernameU;
  final String email;
  final String nomService;
  final int idUser;

  Message({
    required this.id,
    required this.message,
    required this.usernameU,
    required this.email,
    required this.nomService,
    required this.idUser,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      message: json['message'],
      usernameU: json['usernameU'],
      email: json['email'],
      nomService: json['nom_service'],
      idUser: json['idUser'],
    );
  }
}

class MessageList extends StatefulWidget {
  @override
  _MessageListPageState createState() => _MessageListPageState();
}

class _MessageListPageState extends State<MessageList> {
  TextEditingController messageController = TextEditingController();
  late Future<Map<int, List<Message>>> futureMessages;

  @override
  void initState() {
    super.initState();
    futureMessages = fetchMessages();
  }

  Future<Map<int, List<Message>>> fetchMessages() async {
    final String email = TokenStorage.getEmail();

    final response =
        await http.get(Uri.parse('http://localhost:3000/users/message'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        List<Message> messages = data
            .where((json) => json['emailU'].toLowerCase() == email.toLowerCase())
            .map((json) => Message.fromJson(json))
            .toList();  

        Map<int, List<Message>> messagesByUser = {};
        messages.forEach((message) {
          if (!messagesByUser.containsKey(message.idUser)) {
            messagesByUser[message.idUser] = [];
          }
          messagesByUser[message.idUser]!.add(message);
        });
        return messagesByUser;
      } else {
        return {};
      }
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
          ),
        ),
      ),
      body: FutureBuilder<Map<int, List<Message>>>(
        future: futureMessages,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else {
            Map<int, List<Message>> messagesByUser = snapshot.data!;
            return ListView.builder(
              itemCount: messagesByUser.length,
              itemBuilder: (context, index) {
                int userId = messagesByUser.keys.elementAt(index);
                List<Message> messages = messagesByUser[userId]!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ExpansionTile(
                      title: Text('Messages pour l\'utilisateur $userId'),
                      children: messages.map((message) {
                        return Column(
                          children: [
                            ListTile(
                              title: Text(message.message),
                              subtitle:
                                  Text('Envoyé par: ${message.usernameU}'),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                          'Conversation avec ${message.usernameU}'),
                                      content: Column(
                                        children: [
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount: messages.length,
                                            itemBuilder: (context, index) {
                                              Message message = messages[index];
                                              return ListTile(
                                                title: Text(message.message),
                                                subtitle: Text(
                                                    'Envoyé par: ${message.usernameU}'),
                                              );
                                            },
                                          ),
                                          TextField(
                                            controller: messageController,
                                            decoration: InputDecoration(
                                              hintText: 'Votre réponse...',
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Envoyer'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            Divider(),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
