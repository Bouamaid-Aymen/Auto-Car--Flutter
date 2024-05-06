import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_app_car/utils/snackbar_helper.dart';

class CarMaintenancePage extends StatefulWidget {
  final String carId;

  CarMaintenancePage({required this.carId});

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

  final _formKey = GlobalKey<FormState>();
  bool isDateEditable = false;

  @override
  void initState() {
    super.initState();
    dateController = TextEditingController(
      text:
          '${DateTime.now().day.toString().padLeft(2, '0')} - ${DateTime.now().month.toString().padLeft(2, '0')} - ${DateTime.now().year}',
    );
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
        backgroundColor: Colors.green,
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 8),
              Text(
                'Cahier de maintenance ',
              ),
              Icon(Icons.build, color: Colors.white)
            ],
          ),
        ),
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
                  onTap: () {
                    setState(() {
                      isDateEditable = true;
                    });
                  },
                  onChanged: (value) {},
                  controller: dateController,
                  decoration: InputDecoration(
                    labelText: 'Date (JJ-MM-AAAA)',
                  ),
                  readOnly: !isDateEditable,
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
                Text(
                  'Liste des Contrôles',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  controller: constatationsController,
                  decoration: InputDecoration(
                    labelText: 'Constatations - Observations',
                  ),
                ),
                TextFormField(
                  controller: defectuositesController,
                  decoration: InputDecoration(
                    labelText: 'Défectuosités relevées - Infractions signalées',
                  ),
                ),
                TextFormField(
                  controller: essaisFreinageController,
                  decoration: InputDecoration(
                    labelText: 'Essais de freinage',
                  ),
                ),
                TextFormField(
                  controller: distancesArretController,
                  decoration: InputDecoration(
                    labelText: 'Distances d\'arrêt - Décélération',
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: personneOperationController,
                  decoration: InputDecoration(
                    labelText: 'Nom de la personne ayant fait l\'opération',
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: modificationsController,
                  decoration: InputDecoration(
                    labelText: 'Modifications du véhicule',
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: autreController,
                  decoration: InputDecoration(
                    labelText: 'Autre',
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      saveData();
                    }
                  },
                  child: Text(
                    'Enregistrer',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> saveData() async {
    final date = dateController.text;
    final km = kilometresController.text;
    final constatations = constatationsController.text;
    final defectuosites = defectuositesController.text;
    final essaisFreinage = essaisFreinageController.text;
    final distancesArret = distancesArretController.text;
    final personneOperation = personneOperationController.text;
    final modifications = modificationsController.text;
    final autre = autreController.text;

    final url = "http://localhost:3000/voiture/${widget.carId}/maintenance";
    final uri = Uri.parse(url);
    final body = {
      "date": date,
      "km": km,
      "constatations": constatations,
      "defectuosites": defectuosites,
      "essaisFreinage": essaisFreinage,
      "distancesArret": distancesArret,
      "personneOperation": personneOperation,
      "modifications": modifications,
      "autre": autre,
    };
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      kilometresController.text = "";
      constatationsController.text = "";
      defectuositesController.text = "";
      essaisFreinageController.text = "";
      distancesArretController.text = "";
      personneOperationController.text = "";
      modificationsController.text = "";
      autreController.text = "";
      showSuccessMessage(context, message: 'Enregistrer avec succés  ');
    } else {
      print(response.statusCode);
      print(response.body);

      showErroMessage(context, message: 'Échoué');
    }
  }
}
