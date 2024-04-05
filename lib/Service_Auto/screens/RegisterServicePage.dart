import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app_car/Adminisrateur/screens/listeuser.dart';
import 'package:my_app_car/screens/Car_list.dart';
import 'package:my_app_car/screens/register.dart';
import 'package:http/http.dart' as http;

class RegisterServicePage extends StatefulWidget {
  final Map? todo;
  const RegisterServicePage({Key? key, this.todo});

  @override
  State<RegisterServicePage> createState() => _RegisterServicePageState();
}

class _RegisterServicePageState extends State<RegisterServicePage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isEdit = false;
  bool obscureText = true;
  bool hasService = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'SE CONNECTER',
            style: TextStyle(color: Color.fromARGB(255, 112, 183, 242)),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: 'Nom de utilisateur ',
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(Icons.person, color: Colors.blue),
                ),
                onChanged: (value) {},
              ),
              SizedBox(height: 20),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: 'Nom de service',
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(Icons.business,
                      color: Colors.blue),
                ),
                onChanged: (value) {},
              ),
              SizedBox(height: 10),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: 'mot de passe',
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
                keyboardType: TextInputType.text,
                obscureText: obscureText,
                onChanged: (value) {},
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: hasService,
                    onChanged: (value) {
                      setState(() {
                        hasService = value!;
                      });
                    },
                  ),
                  Text('J\'ai un service *',
                      style: TextStyle(
                          color: hasService ? Colors.green : Colors.red)),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: hasService
                    ? () => LoginApi()
                    : null, // Disable button if hasService is false
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'SE CONNECTER',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> LoginApi() async {
    final username = usernameController.text;
    final password = passwordController.text;
    final body = {"username": username, "password": password};

    const url = "http://localhost:3000/users/login";
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 201) {
      Get.snackbar('Succès', 'Bienvenue ☻',
          backgroundColor: Colors.green, snackPosition: SnackPosition.BOTTOM);
      print('Information sent successfully!');
      final token = jsonDecode(response.body)["acces token"];
      final userRole = jsonDecode(response.body)["role"];
      final email = jsonDecode(response.body)["email"];

      TokenStorage.storeToken(token, username, email);

      if (userRole == "SERVICE" && hasService) {
        final route = MaterialPageRoute(builder: (context) => CarListPage());
        await Navigator.push(context, route);
      } else {
        Get.snackbar('Échoué',
            'Échec de l`ajout du service Compte attend la verification ',
            backgroundColor: Colors.red, snackPosition: SnackPosition.BOTTOM);
      }
    }
  }
}
