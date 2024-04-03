import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_app_car/Adminisrateur/screens/listeuser.dart';
import 'package:my_app_car/screens/Car_list.dart';
import 'package:my_app_car/screens/register.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  final Map? todo;
  const LoginPage({Key? key, this.todo});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isEdit = false;
  bool obscureText = true;

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
                  hintText: 'NOM D`UTILISATEUR',
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(Icons.person, color: Colors.blue),
                ),
                onChanged: (value) {},
              ),
              SizedBox(height: 10),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: 'MOT DE PASSE',
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => LoginApi(),
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
              SizedBox(height: 20),
              GestureDetector(
                onTap: navigateToAddServicePage,
                child: Text(
                  'S`INSCRIRE',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> navigateAddPage() async {
    final route = MaterialPageRoute(builder: (context) => RegisterPage());
    await Navigator.push(context, route);
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
      showSuccessMessage('Welcom ☻ ');
      print('Information sent successfully!');
      final token = jsonDecode(response.body)["acces token"];
      final userRole = jsonDecode(response.body)["role"];
      final email = jsonDecode(response.body)["email"];

      TokenStorage.storeToken(token, username, email);

      if (userRole == "USER") {
        final route = MaterialPageRoute(builder: (context) => CarListPage());
        await Navigator.push(context, route);
      } else {
        final route = MaterialPageRoute(builder: (context) => userListPage());
        await Navigator.push(context, route);
      }
    } else {
      print('Failed to send information. Status code: ${response.statusCode}');
      showErrorMessage('Username or Password failed');
    }
  }

  Future<void> navigateToAddServicePage() async {
    final route = MaterialPageRoute(builder: (context) => RegisterPage());
    await Navigator.push(context, route);
  }

  void showErrorMessage(String message) {
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
