import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_app_car/Adminisrateur/screens/Cars.dart';
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
        automaticallyImplyLeading: false,
        title: Center(child: Text('Login')),
      ),
      floatingActionButton: SizedBox(
        width: 200,
        child: FloatingActionButton.extended(
          onPressed: navigateAddPage,
          label: Text('SINGUP'),
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
            hintText: 'USERNAME',
            prefixIcon: Icon(Icons.person),
          ),
          onChanged: (value) {
            // Appliquer un filtre à value si nécessaire
          },
        ),
        SizedBox(height: 10),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
            hintText: 'PASSWORD',
            prefixIcon: Icon(Icons.lock),
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
          onChanged: (value) {
            // Appliquer un filtre à value si nécessaire
          },
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => LoginApi(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Connection'),
          ),
        )
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
      print(userRole);
      TokenStorage.storeToken(token);
      if (userRole == "USER") {
        final route = MaterialPageRoute(builder: (context) => CarListPage());
        await Navigator.push(context, route);
      } else {
        final route = MaterialPageRoute(builder: (context) => DropdownScreen());
        await Navigator.push(context, route);
      }
    } else {
      print('Failed to send information. Status code: ${response.statusCode}');
      showErrorMessage('Username or Password failed');
    }
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
      content: Center(child: Text(message)),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
