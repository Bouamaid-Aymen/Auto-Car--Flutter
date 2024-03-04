import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_app_car/screens/car_list.dart';
import 'package:my_app_car/screens/register.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  final Map? todo;
  const LoginPage({super.key, this.todo});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isEdit = false;
  @override
  void initState() {
    super.initState();
    /*final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Login')),
      ),
      floatingActionButton: SizedBox(
        width: 200,
        child: FloatingActionButton.extended(
            onPressed: navigateAddPage, label: Text('SINGUP')),
      ),
      body: SizedBox(
        child: Center(
          child: ListView(
            padding: EdgeInsets.all(20),
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(hintText: 'USERNAME'),
              ),
              Center(
                child: TextField(
                  controller: passwordController,
                  decoration: InputDecoration(hintText: 'PASSWORD'),
                  keyboardType: TextInputType.multiline,
                  obscureText: true,
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () => LoginApi(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Connection'),
                  ),
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
      TokenStorage.storeToken(token);
      final route = MaterialPageRoute(builder: (context) => CarListPage());
      await Navigator.push(context, route);
    } else {
      print('Failed to send information. Status code: ${response.statusCode}');
      showErroMessage('Username or Password failed');
    }
  }

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
      content: Center(
        child: Text(
          message,
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
