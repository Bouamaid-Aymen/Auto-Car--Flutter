import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app_car/utils/snackbar_helper.dart';

class Car extends StatefulWidget {
  final Map? car;

  const Car({Key? key, this.car}) : super(key: key);

  @override
  State<Car> createState() => _CarState();
}

class _CarState extends State<Car> {
  List data = [];
  int _value = 1;
  TextEditingController brandController = TextEditingController();
  TextEditingController modelController = TextEditingController();

  void showAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(197, 158, 158, 158),
        title: Text("CAR"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter vehicle information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: DropdownButton(
                      items: data.map((e) {
                        return DropdownMenuItem(
                          child: Text(e["name"]),
                          value: e["id"],
                        );
                      }).toList(),
                      value: _value,
                      onChanged: (v) {
                        _value = v as int;
                      }),
                ),
                const SizedBox(width: 20),
                
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: brandController,
                    onChanged: (value) {
                      setState(() {
                        // Ajoutez votre logique ici
                      });
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Enter votre brand',
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextFormField(
                    controller: modelController,
                    onChanged: (value) {
                      setState(() {
                        // Ajoutez votre logique ici
                      });
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(labelText: 'Enter votre model'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: AddBrand,
                  child: Text('Ajoute'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Ajoutez votre logique ici
                  },
                  child: Text('Supprimer'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> AddBrand() async {
    final brand = brandController.text;
    const url = "http://localhost:3000/car/brand";
    final uri = Uri.parse(url);
    final body = {"name": brand};
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 201) {
      showSuccessMessage(context, message: " Update Success");
      print('Information sent successfully!');
    } else {
      print('Failed to send information. Status code: ${response.statusCode}');
      showErroMessage(context, message: 'Creation failed');
    }
  }

  Future<void> getData() async {
    const url = "http://localhost:3000/car/brand";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    data = jsonDecode(response.body);
    setState(() {});
    if (response.statusCode == 200) {
      print(response.body);
      setState(() {});
    } else {
      print(response.statusCode);
    }
  }
}
