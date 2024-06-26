import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:my_app_car/screens/Car_list.dart';
import 'package:my_app_car/utils/snackbar_helper.dart';

class MyCar extends StatefulWidget {
  final Map? car;

  const MyCar({Key? key, this.car}) : super(key: key);

  @override
  State<MyCar> createState() => _MyCarState();
}

class _MyCarState extends State<MyCar> {
  var _brands = [];
  var _models = [];
  String? selectedBrand;
  String? selectedModel;
  String? selectedBrandId;

  bool isBrandSelected = false;

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
    getWorldData();
  }

  @override
  void dispose() {
    ageController.dispose();
    kmController.dispose();
    lastOilChangeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(isEdit ? 'MODIFIER VOITURE' : 'Ajouter une voiture'),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            if (_brands.isEmpty)
              const Center(child: CircularProgressIndicator())
            else
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: DropdownButton<String>(
                    underline: Container(),
                    hint: Text('Choisir la marque'),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    isDense: true,
                    isExpanded: true,
                    value: selectedBrand,
                    onChanged: (value) {
                      setState(() {
                        selectedBrand = value;
                        isBrandSelected = true;
                        selectedModel = null;
                        for (int i = 0; i < _brands.length; i++) {
                          if (_brands[i]['name'] == value) {
                            _models = _brands[i]['model'];
                            selectedBrandId = _brands[i]['id'].toString();
                          }
                        }
                      });
                    },
                    items: _brands.map((brand) {
                      return DropdownMenuItem<String>(
                          value: brand['name'], child: Text(brand['name']));
                    }).toList(),
                  ),
                ),
              ),
            if (isBrandSelected)
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  child: DropdownButton<String>(
                    underline: Container(),
                    hint: Text('Choisire le modèle'),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    isDense: true,
                    isExpanded: true,
                    value: selectedModel,
                    onChanged: (value) {
                      setState(() {
                        selectedModel = value;
                      });
                    },
                    items: _models.map((model) {
                      return DropdownMenuItem<String>(
                          value: model['name'], child: Text(model['name']));
                    }).toList(),
                  ),
                ),
              )
            else
              Container(),
            const SizedBox(height: 20),
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
                labelText: 'Entrez l`âge du véhicule',
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
                labelText: 'Entrez les kilomètres',
                prefixIcon: Icon(Icons.directions_car),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isEdit
                  ? updateData
                  : () => sendCarInformation(
                        selectedBrand,
                        selectedModel,
                        age,
                        km,
                        lastOilChangeDate.toString(),
                      ),
              child: Text(
                isEdit ? 'Enregistrer' : 'Enregistrer',
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sendCarInformation(String? brand, String? model, String age, String km,
      String lastOilChangeDate) async {
    Map<String, String> body = {
      'brand': brand!,
      'model': model!,
      'age': age,
      'km': km,
      'lastOilChangeDate': lastOilChangeDate,
    };
    String? token = await TokenStorage.getToken();
    const url = 'http://localhost:3000/voiture/add';
    final uri = Uri.parse(url);
    final response = await http.post(uri, body: jsonEncode(body), headers: {
      'Content-Type': 'application/json',
      'authorization': 'Bearer $token'
    });

    if (response.statusCode == 201) {
      ageController.text = '';
      kmController.text = '';
      lastOilChangeController.text = '';
      final route = MaterialPageRoute(builder: (context) => CarListPage());
      await Navigator.push(context, route);
      showSuccessMessage(context, message: 'Creation Success ☻ ');
    } else {
      print(response.statusCode);
      print(
          'Failed to send car information. Status code: ${response.statusCode}');
      showErroMessage(context, message: 'Creation failed');
    }
  }

  Future<void> updateData() async {
    final car = widget.car;
    if (car == null) {
      print('You can not call update without car  ');
      return;
    }
    final id = car['Id'];
    final age = ageController.text;
    final km = kmController.text;
    final lastOilChange = lastOilChangeController.text;

    final body = {'age': age, 'km': km, 'lastOilChange': lastOilChange};
    final url = 'http://localhost:3000/voiture/$id';
    final uri = Uri.parse(url);
    final response = await http.patch(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      showSuccessMessage(context, message: ' Update Success');
    } else {
      print(response.statusCode);
      showErroMessage(context, message: 'Updation failed');
    }
  }

  Future<void> getWorldData() async {
    const url = 'http://localhost:3000/car/brand';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      setState(() {
        _brands = jsonResponse;
      });
    }
  }
}
