import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AddServicePage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController serviceNameController = TextEditingController();

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
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email, color: Colors.blue),
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
        
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nom',
                prefixIcon: Icon(Icons.person, color: Colors.blue),
                labelStyle: TextStyle(color: Colors.white),
              ),
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
              onPressed: addService,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(1),
                backgroundColor: Colors.blue,
              ),
              child: Text(
                'Ajouter le service',
                style: TextStyle(
                    color:
                        Colors.white),
              ),
            ),
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

    final body = {
      'email': email,
      'nomS': nom,
      'nomP': nomP,
      'tel': tel,
      'adress': address,
    };
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    print(response.body);

    if (response.statusCode == 201) {
      Get.snackbar('succès', 'Service ajouté avec succès',
          backgroundColor: Colors.green, snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar('Échoué', 'Échec de l`ajout du service',
          backgroundColor: Colors.red, snackPosition: SnackPosition.BOTTOM);
    }
  }
}
