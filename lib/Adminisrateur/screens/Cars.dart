import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app_car/utils/NavBarAdmin.dart';
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
      drawer: NavBarAdmin(),
      appBar: AppBar(
        title: Center(child: Text("Ajouter Marque & Modél  ")),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_brands.isEmpty)
              const Center(child: CircularProgressIndicator())
            else
              Card(

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DropdownButton<String>(
                        underline: Container(),
                        hint: Text("Choisir une marque"),
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
                        }).toList(),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: brandController,
                        onChanged: (value) {
                          setState(() {});
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Enter votre brand',
                        ),
                      ),
                      SizedBox(height: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: AddBrand,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.green,
                            ),
                            child: Text('Ajouter des marques'),
                          ),
                          SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: deletebrandmodel,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.red,
                            ),
                            child: Text('Supprimer des marques'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(height: 20),
            if (isBrandSelected)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DropdownButton<String>(
                        underline: Container(),
                        hint: Text("Choisir une modél"),
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
                        }).toList(),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: modelController,
                        onChanged: (value) {
                          setState(() {});
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Enter votre model',
                        ),
                      ),
                      SizedBox(height: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: addmodeltobrand,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.green,
                            ),
                            child: Text('Ajouter des modèles'),
                          ),
                          SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: deletemodel,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.red,
                            ),
                            child: Text('Supprimer des modèles'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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
      brandController.text = "";
      modelController.text = "";
      showSuccessMessage(context, message: " La création avec succès");
    } else {
      showErroMessage(context, message: 'La création a échoué');
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
        modelController.text = "";
        showSuccessMessage(context,
            message: "Nouveau modèle ajouté à la marque : $selectedBrand");
      } else {
        showErroMessage(context, message: 'La création a échoué');
      }
    } else {
      showErroMessage(context, message: 'Aucune marque sélectionnée');
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
      setState(() {
        _brands
            .removeWhere((brand) => brand["id"].toString() == selectedBrandId);
        selectedBrand = null;
        selectedBrandId = null;
      });
      showSuccessMessage(context, message: "Suppression avec succès");
    } else {
      showErroMessage(context, message: 'Suppression avec échoué');
    }
  }

  Future<void> deletemodel() async {
    if (selectedBrandId != null && selectedModel != null) {
      final url = "http://localhost:3000/car/$selectedBrandId/model/";
      final uri = Uri.parse(url);
      final response = await http.delete(uri);

      if (response.statusCode == 200) {
        setState(() {
          _models
              .removeWhere((model) => model["id"].toString() == selectedModel);
          selectedModel = null;
        });
        showSuccessMessage(context, message: "Suppression avec succès");
      } else {
        showErroMessage(context, message: 'Suppression avec échoué');
      }
    } else {
      showErroMessage(context, message: 'Aucune marque ou modèle sélectionné');
    }
  }
}
