import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final Map? todo;
  const RegisterPage({super.key, this.todo});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isEdit = false;
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('SINGUP')),
      ),
      body: SizedBox(
        child: Center(
          child: Center(
            child: ListView(
              padding: EdgeInsets.all(20),
              children: [
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'EMAIL',
                  ),
                ),
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(hintText: 'USERNAME'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(hintText: 'PASSWORD'),
                  keyboardType: TextInputType.multiline,
                  obscureText: true,
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: RegisterApi,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('SINGUP'),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> RegisterApi() async {
    final email = emailController.text;
    final username = usernameController.text;
    final password = passwordController.text;
    final body = {"email": email, "username": username, "password": password};
    const url = "http://localhost:3000/users/register";
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 201) {
      showSuccessMessage('Creation Success ☻ ');
      print('Information sent successfully!');
    } else {
      print('Failed to send information. Status code: ${response.statusCode}');
      showErroMessage('Creation failed ');
    }
  }

  //API Response Recation
  void showErroMessage(String message) {
    final snackBar = SnackBar(
      content:
          Center(child: Text(message, style: TextStyle(color: Colors.white))),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(
      content:
          Center(child: Text(message, style: TextStyle(color: Colors.white))),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
