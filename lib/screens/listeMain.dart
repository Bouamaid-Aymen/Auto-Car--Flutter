import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:my_app_car/screens/maintenance.dart';
import 'package:my_app_car/utils/snackbar_helper.dart';

class MaintenanceListPage extends StatefulWidget {
  final String carId;

  MaintenanceListPage({required this.carId});

  @override
  _MaintenanceListPageState createState() => _MaintenanceListPageState();
}

class _MaintenanceListPageState extends State<MaintenanceListPage> {
  late List<dynamic> maintenanceList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final url = "http://localhost:3000/voiture/${widget.carId}/maintenance";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        maintenanceList = jsonDecode(response.body);
      });
    } else {
      // Handle error
    }
  }

  Future<void> deleteMaintenance(int id) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content:
              Text('Êtes-vous sûr de vouloir supprimer cette maintenance ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final uri =
                    Uri.parse('http://localhost:3000/voiture/$id/maitenance');
                final response = await http.delete(uri);
                if (response.statusCode == 200) {
                  fetchData();
                  showSuccessMessage(context,
                      message: 'Voyant supprimé avec succès');
                } else {
                  print(response.body);
                  showErroMessage(context,
                      message: 'Échec de la suppression du voyant');
                }
              },
              child: Text('Confirmer'),
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
        backgroundColor: Color.fromARGB(255, 60, 0, 129),
        title: Center(child: Text('Liste des maintenances')),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CarMaintenancePage(carId: widget.carId)),
              );
            },
            icon: Tooltip(
              message: 'Ajouter maintenance',
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: maintenanceList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchData,
              child: ListView.builder(
                itemCount: maintenanceList.length,
                itemBuilder: (context, index) {
                  final maintenance = maintenanceList[index];
                  final int id = maintenance['id'];
                  return Card(
                    child: ListTile(
                      leading: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          deleteMaintenance(id);
                        },
                      ),
                      title: Column(
                        children: [
                          SizedBox(height: 10),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Date : ',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  TextSpan(
                                    text: '${maintenance["date"]}',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  TextSpan(
                                    text: ' - Kilomètres: ',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  TextSpan(
                                    text: '${maintenance["km"]}',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MaintenanceDetailsPage(
                                maintenance: maintenance),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class MaintenanceDetailsPage extends StatelessWidget {
  final dynamic maintenance;

  MaintenanceDetailsPage({required this.maintenance});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Center(child: Text('Détails de la maintenance')),
      ),
      body: SizedBox.expand(
        child: Container(
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMaintenanceItem("Date", maintenance["date"]),
              _buildMaintenanceItem("Kilomètres", maintenance["km"].toString()),
              _buildMaintenanceItem(
                  "Constatations", maintenance["constatations"]),
              _buildMaintenanceItem(
                  "Défectuosités", maintenance["defectuosites"]),
              _buildMaintenanceItem(
                  "Essais de freinage", maintenance["essaisFreinage"]),
              _buildMaintenanceItem(
                  "Distances d'arrêt", maintenance["distancesArret"]),
              _buildMaintenanceItem(
                  "Personne opération", maintenance["personneOperation"]),
              _buildMaintenanceItem(
                  "Modifications", maintenance["modifications"]),
              _buildMaintenanceItem("Autre", maintenance["autre"]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMaintenanceItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
