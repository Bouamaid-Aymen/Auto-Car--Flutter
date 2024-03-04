import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:my_app_car/screens/car_list.dart';
import 'package:my_app_car/utils/snackbar_helper.dart';

class MyCar extends StatefulWidget {
  final Map? car;

  const MyCar({Key? key, this.car}) : super(key: key);

  @override
  State<MyCar> createState() => _MyCarState();
}

class _MyCarState extends State<MyCar> {
  List<String> vehicleBrands = [
    'Toyota',
    'Honda',
    'Ford',
    'Chevrolet',
    'Volkswagen',
  ];
  Map<String, List<String>> vehicleModels = {
    'Toyota': ['Camry', 'Corolla', 'Rav4'],
    'Honda': ['Accord', 'Civic', 'CR-V'],
    'Ford': ['F-150', 'Escape', 'Focus'],
    'Chevrolet': ['Silverado', 'Equinox', 'Malibu'],
    'Volkswagen': ['Jetta', 'Tiguan', 'Passat'],
  };
  String selectedBrand = 'Toyota';
  String selectedModel = 'Camry';
  String age = '';
  String km = '';
  DateTime? lastOilChangeDate;

  final ageController = TextEditingController();
  final kmController = TextEditingController();
  final lastOilChangeController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final car = widget.car;
    if (car != null) {
      isEdit = true;
    }
  }

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

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(197, 158, 158, 158),
        title: Text(isEdit ? 'EditCar' : " MY CAR "),
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
                        selectedModel = vehicleModels[selectedBrand]![0];
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
                    items: vehicleModels[selectedBrand]!.map((String model) {
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
              onPressed: isEdit
                  ? updateData
                  : () => sendCarInformation(selectedBrand, selectedModel, age,
                      km, lastOilChangeDate.toString()),
              child: Text(isEdit ? 'Update' : 'Submit'),
            ),
          ],
        ),
      ),
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
    String? token = await TokenStorage.getToken();
    const url = "http://localhost:3000/voiture/add";
    final uri = Uri.parse(url);
    final response = await http.post(uri, body: jsonEncode(body), headers: {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    });

    if (response.statusCode == 201) {
      ageController.text = "";
      kmController.text = "";
      lastOilChangeController.text = "";
      showSuccessMessage(context, message:'Creation Success ☻ ');
    } else {
      print(
          'Failed to send car information. Status code: ${response.statusCode}');
      showErroMessage(context, message:'Creation failed');
    }
  }

  Future<void> updateData() async {
    final car = widget.car;
    if (car == null) {
      print('You can not call update without car  ');
      return;
    }
    final id = car["Id"];
    final age = ageController.text;
    final km = kmController.text;
    final lastOilChange = lastOilChangeController.text;

    final body = {"age": age, "km": km, "lastOilChange": lastOilChange};
    final url = "http://localhost:3000/voiture/$id";
    final uri = Uri.parse(url);
    final response = await http.patch(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    
    if (response.statusCode == 200) {
      showSuccessMessage(context, message: " Update Success");
    } else {
      print(response.statusCode);
      showErroMessage(context, message:'Updation failed');
    }
  }
}
