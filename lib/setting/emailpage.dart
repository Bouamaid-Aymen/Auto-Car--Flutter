import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:my_app_car/screens/Car_list.dart';

class ChangeEmailPage extends StatefulWidget {
  const ChangeEmailPage({Key? key}) : super(key: key);

  @override
  State<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  bool _obscurePassword = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  String username = TokenStorage.getUsername();
  String email = TokenStorage.getEmail();

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Center(
            child: Text(
          'Enregistrer',
          style: TextStyle(color: Colors.white),
        )),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.person, color: Colors.blue),
                SizedBox(width: 10),
                Text(username),
              ],
            ),
            SizedBox(height: 5),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.email, color: Colors.blue),
                SizedBox(width: 10),
                Text(email),
              ],
            ),
            SizedBox(height: 20),
            Text('Nom d\'utilisateur'),
            SizedBox(height: 10),
            TextFormField(
              controller: usernameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text('Email'),
            SizedBox(height: 10),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text('Mot de passe'),
            SizedBox(height: 10),
            TextFormField(
              controller: passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: _togglePasswordVisibility,
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  updateUser(email);
                },
                child: Text(
                  'Modifier le profil',
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateUser(String email) async {
    final password = passwordController.text;
    final newEmail = emailController.text;
    final newUsername = usernameController.text;
    final body = {
      "email": email,
      "newemail": newEmail,
      "newusername": newUsername,
      "oldPassword": password,
    };
    const url = "http://localhost:3000/users/update-Email";
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      passwordController.text = "";
      emailController.text = "";
      usernameController.text = "";

      Get.snackbar('Succès', 'Profil mis à jour',
          backgroundColor: Colors.green, snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar('Erreur', 'Mise à jour du profil échouée',
          backgroundColor: Colors.red, snackPosition: SnackPosition.BOTTOM);
    }
  }
}
