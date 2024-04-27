import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final Map? todo;
  const RegisterPage({Key? key, this.todo}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool obscureText = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController TelController = TextEditingController();
  bool isEdit = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'S`inscrire',
            style: TextStyle(color: Colors.blue),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(40),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(Icons.person, color: Colors.blue),
                ),
              ),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: 'Nom d`utilisateur',
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(Icons.person, color: Colors.blue),
                ),
              ),
              TextField(
                controller: TelController,
                decoration: InputDecoration(
                  hintText: 'Tel',
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(Icons.person, color: Colors.blue),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9_]')),
                  LengthLimitingTextInputFormatter(8),
                ],
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: 'Mot de passe',
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(Icons.lock, color: Colors.blue),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                  ),
                ),
                keyboardType: TextInputType.multiline,
                obscureText: obscureText,
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: registerApi,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'S`inscrire',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> registerApi() async {
    final email = emailController.text;
    final username = usernameController.text;
    final password = passwordController.text;
    final tel = TelController.text;
    final body = {
      "email": email,
      "username": username,
      "tel": tel,
      "password": password
    };
    const url = "http://localhost:3000/users/register";
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      showSuccessMessage('Succès de la création ☻ ');
      print('Information sent successfully!');
    } else {
      print(
          'Échec de l`envoi des informations. Status code: ${response.statusCode}');
      showErrorMessage('La création a échoué ');
    }
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Center(
        child: Text(message, style: TextStyle(color: Colors.white)),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(
      content: Center(
        child: Text(message, style: TextStyle(color: Colors.white)),
      ),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
