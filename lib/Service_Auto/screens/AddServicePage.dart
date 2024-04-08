import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AddServicePage extends StatefulWidget {
  @override
  _AddServicePageState createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController serviceNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Ajouter un service')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nom',
                prefixIcon: Icon(Icons.person, color: Colors.blue),
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email, color: Colors.blue),
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                prefixIcon: Icon(Icons.lock, color: Colors.blue),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.blue,
                  ),
                  onPressed: _togglePasswordVisibility,
                ),
                labelStyle: TextStyle(color: Colors.white),
              ),
              obscureText: _obscureText,
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Téléphone',
                prefixIcon: Icon(Icons.phone, color: Colors.blue),
                labelStyle: TextStyle(color: Colors.white),
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: 'Adresse',
                prefixIcon: Icon(Icons.location_on, color: Colors.blue),
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
            TextField(
              controller: serviceNameController,
              decoration: InputDecoration(
                labelText: 'Nom du service',
                prefixIcon: Icon(Icons.room_service, color: Colors.blue),
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                addService();
              
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(1),
                backgroundColor: Colors.blue,
              ),
              child: Text(
                'Ajouter le service',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            
          ],
        ),
      ),
    );
  }

  Future<void> addService() async {
    const url = 'http://localhost:3000/car/service';
    final uri = Uri.parse(url);
    final email = emailController.text;
    final nom = serviceNameController.text;
    final nomP = nameController.text;
    final tel = phoneController.text;
    final address = addressController.text;
    final password = passwordController.text;

    final body = {
      'nomS': nom,
      'email': email,
      'nomP': nomP,
      'tel': tel,
      'adress': address,
      "password": password
    };
  
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      Get.snackbar('succès', 'Service ajouté avec succès',
          backgroundColor: Colors.green, snackPosition: SnackPosition.BOTTOM);
    } else {
      print(response.statusCode);
      Get.snackbar('Échoué', 'Échec de l`ajout du service',
          backgroundColor: Colors.red, snackPosition: SnackPosition.BOTTOM);
    }
  }


}
