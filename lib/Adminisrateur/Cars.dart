import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app_car/utils/snackbar_helper.dart';

class DropdownScreen extends StatefulWidget {
  @override
  State<DropdownScreen> createState() => _DropdownScreenState();
}

class _DropdownScreenState extends State<DropdownScreen> {
  var _brands = [];
  var _models = [];
  TextEditingController brandController = TextEditingController();
  TextEditingController modelController = TextEditingController();

  String? selectedBrand;
  String? selectedModel;
  String? selectedBrandId;

  bool isBrandSelected = false;

  @override
  void initState() {
    getWorldData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getWorldData();
    return Scaffold(
      appBar: AppBar(title: Text("CARS")),
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
                      hint: Text("Select Brand"),
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
                            if (_brands[i]["name"] == value) {
                              _models = _brands[i]["model"];
                              selectedBrandId = _brands[i]["id"].toString();
                            }
                          }
                        });
                      },
                      items: _brands.map((brand) {
                        return DropdownMenuItem<String>(
                            value: brand["name"], child: Text(brand["name"]));
                      }).toList()),
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
                      hint: Text("Select Model"),
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
                            value: model["id"].toString(),
                            child: Text(model["name"]));
                      }).toList()),
                ),
              )
            else
              Container(),
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
                  child: Text('ADD BRAND'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: deletebrandmodel,
                  child: Text('DELETE'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: addmodeltobrand,
                  child: Text('ADD MODEL '),
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
      print(selectedBrand);
    } else {
      showErroMessage(context, message: 'Creation failed');
    }
  }

  Future<void> addmodeltobrand() async {
    final model = modelController.text;
    if (selectedBrandId != null) {
      final url = "http://localhost:3000/car/$selectedBrandId/model";
      final uri = Uri.parse(url);
      final body = {"name": model};
      final response = await http.post(uri,
          body: jsonEncode(body),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 201) {
        showSuccessMessage(context,
            message: "New model added to brand: $selectedBrand");
      } else {
        showErroMessage(context, message: 'Creation failed');
      }
    } else {
      showErroMessage(context, message: 'No brand selected');
    }
  }

  Future getWorldData() async {
    const url = "http://localhost:3000/car/brand";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      setState(() {
        _brands = jsonResponse;
      });
    }
  }

  Future<void> deletebrandmodel() async {
    final url = "http://localhost:3000/car/$selectedBrandId";
    final uri = Uri.parse(url);
    final response = await http.delete(uri);

    if (response.statusCode == 200) {
      final route = MaterialPageRoute(builder: (context) => DropdownScreen());
      await Navigator.push(context, route);
    } else {
      print(response.body);
    }
  }
}
