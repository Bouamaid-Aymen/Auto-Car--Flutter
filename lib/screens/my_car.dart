import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class MyCar extends StatefulWidget {
  const MyCar({Key? key}) : super(key: key);

  @override
  State<MyCar> createState() => _MyCarState();
}

class _MyCarState extends State<MyCar> {
  List<String> vehicleBrands = [
    'Brand A',
    'Brand B',
    'Brand C',
    'Brand D',
    'Brand E',
    'Brand F',
    'Brand G'
  ];
  List<String> vehicleModels = ['Model A', 'Model B', 'Model C'];
  String selectedBrand = 'Brand A';
  String selectedModel = 'Model A';
  String age = '';
  String km = '';
  DateTime? lastOilChangeDate;

  final ageController = TextEditingController();
  final kmController = TextEditingController();
  final lastOilChangeController = TextEditingController();

  @override
  void dispose() {
    ageController.dispose();
    kmController.dispose();
    lastOilChangeController.dispose();
    super.dispose();
  }

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

  void sendCarInformation(String brand, String model, String age, String km,
      String lastOilChangeDate) async {
    Map<String, String> body = {
      'brand': brand,
      'model': model,
      'age': age,
      'km': km,
      'lastOilChangeDate': lastOilChangeDate,
    };
    
    const url = "http://localhost:3000/voiture/add";
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    print(body);
    print(url);

    if (response.statusCode == 201) {
      print('Car information sent successfully!');
    } else {
      print(
          'Failed to send car information. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(" MY CAR "),
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
                  child: DropdownButton<String>(
                    value: selectedBrand,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedBrand = newValue!;
                      });
                    },
                    items: vehicleBrands.map((String brand) {
                      return DropdownMenuItem<String>(
                        value: brand,
                        child: Row(
                          children: [
                            Icon(Icons.directions_car),
                            SizedBox(width: 5),
                            Text(brand),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedModel,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedModel = newValue!;
                      });
                    },
                    items: vehicleModels.map((String model) {
                      return DropdownMenuItem<String>(
                        value: model,
                        child: Row(
                          children: [
                            Icon(Icons.directions_car),
                            SizedBox(width: 5),
                            Text(model),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: ageController,
              onChanged: (value) {
                setState(() {
                  age = value;
                });
              },
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: 'Enter age of the vehicle',
                prefixIcon: Icon(Icons.calendar_today),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: kmController,
              onChanged: (value) {
                setState(() {
                  km = value;
                });
              },
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: 'Enter kilometers',
                prefixIcon: Icon(Icons.directions_car),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: lastOilChangeController,
              onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null) {
                  setState(() {
                    lastOilChangeDate = selectedDate;
                    lastOilChangeController.text = selectedDate.toString();
                  });
                }
              },
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Enter last oil change date',
                prefixIcon: Icon(Icons.event),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (age.isNotEmpty &&
                    km.isNotEmpty &&
                    lastOilChangeDate != null) {
                  sendCarInformation(selectedBrand, selectedModel, age, km,
                      lastOilChangeDate.toString());
                } else {
                  showAlert('Please fill in all fields.');
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
