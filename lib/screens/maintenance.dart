import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:my_app_car/utils/snackbar_helper.dart';

class CarMaintenancePage extends StatefulWidget {
  @override
  _CarMaintenancePageState createState() => _CarMaintenancePageState();
}

class _CarMaintenancePageState extends State<CarMaintenancePage> {
  late TextEditingController dateController;
  late TextEditingController kilometresController;
  late TextEditingController constatationsController;
  late TextEditingController defectuositesController;
  late TextEditingController essaisFreinageController;
  late TextEditingController distancesArretController;
  late TextEditingController personneOperationController;
  late TextEditingController modificationsController;
  late TextEditingController autreController;

  String date = '';
  String kilometresParcourus = '';
  String controleTechniqueConstatations = '';
  String controleTechniqueDefectuosites = '';
  String controleTechniqueEssaisFreinage = '';
  String controleTechniqueDistancesArretDeceleration = '';
  String personneOperation = '';
  String modificationsVehicule = '';
  String Autre = '';
  List<String> savedChecklists = [];

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    dateController = TextEditingController();
    kilometresController = TextEditingController();
    constatationsController = TextEditingController();
    defectuositesController = TextEditingController();
    essaisFreinageController = TextEditingController();
    distancesArretController = TextEditingController();
    personneOperationController = TextEditingController();
    modificationsController = TextEditingController();
    autreController = TextEditingController();
  }

  @override
  void dispose() {
    dateController.dispose();
    kilometresController.dispose();
    constatationsController.dispose();
    defectuositesController.dispose();
    essaisFreinageController.dispose();
    distancesArretController.dispose();
    personneOperationController.dispose();
    modificationsController.dispose();
    autreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cahier de maintenance de voiture'),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Liste des contrôles techniques enregistrés'),
                    content: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: savedChecklists
                            .map(
                                (checklist) => ListTile(title: Text(checklist)))
                            .toList(),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Fermer'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      date = value;
                    });
                  },
                  initialValue:
                      '${DateTime.now().day.toString().padLeft(2, '0')} - ${DateTime.now().month.toString().padLeft(2, '0')} - ${DateTime.now().year}',
                  decoration: InputDecoration(
                    labelText: 'Date (JJ-MM-AAAA)',
                  ),
                  readOnly: true, // Rend le champ de date en lecture seule
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ce champ est obligatoire';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: kilometresController,
                  decoration: InputDecoration(
                    labelText: 'Kilomètres parcourus (nombre)',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ce champ est obligatoire';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                SizedBox(height: 20),
                Text('Contrôle technique',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                TextFormField(
                  controller: constatationsController,
                  decoration: InputDecoration(
                      labelText: 'Constatations - Observations'),
                ),
                TextFormField(
                  controller: defectuositesController,
                  decoration: InputDecoration(
                      labelText:
                          'Défectuosités relevées - Infractions signalées'),
                ),
                TextFormField(
                  controller: essaisFreinageController,
                  decoration: InputDecoration(labelText: 'Essais de freinage'),
                ),
                TextFormField(
                  controller: distancesArretController,
                  decoration: InputDecoration(
                      labelText: 'Distances d\'arrêt - Décélération'),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: personneOperationController,
                  decoration: InputDecoration(
                      labelText: 'Nom de la personne ayant fait l\'opération'),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: modificationsController,
                  decoration:
                      InputDecoration(labelText: 'Modifications du véhicule'),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: autreController,
                  decoration: InputDecoration(labelText: 'Autre'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Enregistrer les données
                      String checklist =
                          'Date: ${dateController.text}\nKilomètres parcourus: ${kilometresController.text}\n'
                          'Constatations - Observations: ${constatationsController.text}\n'
                          'Défectuosités relevées - Infractions signalées: ${defectuositesController.text}\n'
                          'Essais de freinage: ${essaisFreinageController.text}\n'
                          'Distances d\'arrêt - Décélération: ${distancesArretController.text}\n'
                          'Nom de la personne ayant fait l\'opération: ${personneOperationController.text}\n'
                          'Modifications du véhicule: ${modificationsController.text}\n'
                          'Description: ${autreController.text}';
                      savedChecklists.add(checklist);
                      dateController.clear();
                      kilometresController.clear();
                      constatationsController.clear();
                      defectuositesController.clear();
                      essaisFreinageController.clear();
                      distancesArretController.clear();
                      personneOperationController.clear();
                      modificationsController.clear();
                      autreController.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Données enregistrées')));
                    }
                  },
                  child: Text('Enregistrer'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> cahierMaintenace() async {
    final date = dateController.text;
    final km = kilometresController.text;
    final constatations = constatationsController.text;
    final defectuosites = defectuositesController.text;
    final essaisFreinage = essaisFreinageController.text;
    final distancesArret = distancesArretController.text;
    final personneOperation = personneOperationController.text;
    final modifications = modificationsController.text;
    final autre=autreController.text;
    
    const url = "";
    final uri = Uri.parse(url);
    final body = {
      "date":date,
      "km":km,
      "constatations":constatations,
      "defectuosites":defectuosites,
      "essaisFreinage":essaisFreinage,
      "distancesArret":distancesArret,
      "personneOperation":personneOperation,
      "modifications":modifications,
      "autre":autre
    };
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
}
