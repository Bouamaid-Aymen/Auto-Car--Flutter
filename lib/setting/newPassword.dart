import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:my_app_car/screens/Car_list.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  TextEditingController pasNController = TextEditingController();
  TextEditingController pasOController = TextEditingController();
  String username = TokenStorage.getUsername();
  String email = TokenStorage.getEmail();

  void _toggleOldPasswordVisibility() {
    setState(() {
      _obscureOldPassword = !_obscureOldPassword;
    });
  }

  void _toggleNewPasswordVisibility() {
    setState(() {
      _obscureNewPassword = !_obscureNewPassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Center(
            child: Text(
          'Changer le mot de passe',
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
            SizedBox(height: 5),
            SizedBox(height: 20),
            Text('Ancien mot de passe'),
            SizedBox(height: 10),
            TextFormField(
              controller: pasOController,
              obscureText: _obscureOldPassword,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscureOldPassword
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: _toggleOldPasswordVisibility,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('Nouveau mot de passe'),
            SizedBox(height: 10),
            TextFormField(
              controller: pasNController,
              obscureText: _obscureNewPassword,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscureNewPassword
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: _toggleNewPasswordVisibility,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('Confirmer le nouveau mot de passe'),
            SizedBox(height: 10),
            TextFormField(
              obscureText: _obscureConfirmPassword,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirmPassword
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: _toggleConfirmPasswordVisibility,
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    upPassword(email);
                  },
                  child: Text(
                    'Enregister',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> upPassword(String email) async {
    final passwordN = pasNController.text;
    final passwordO = pasOController.text;
    final body = {
      "email": email,
      "oldPassword": passwordO,
      "newPassword": passwordN
    };
    const url = "http://localhost:3000/users/update-password";
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      Get.snackbar('succès', 'Modifier password ',
          backgroundColor: Colors.green, snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar('Errore', ' Password failed',
          backgroundColor: Colors.red, snackPosition: SnackPosition.BOTTOM);
    }
  }
}
