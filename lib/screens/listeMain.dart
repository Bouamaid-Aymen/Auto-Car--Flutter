import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 60, 0, 129),
        title: Center(child: Text('Liste des maintenances')),
      ),
      body: 
      maintenanceList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: maintenanceList.length,
              itemBuilder: (context, index) {
                final maintenance = maintenanceList[index];
                return Card(
                  child: ListTile(
                    title: Column(
                      children: [
                        SizedBox(height: 8),
                        Center(
                          child: Text(
                            'Maintenance',
                            style: TextStyle(
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Center(
                      child: Text(
                        'Date: ${maintenance["date"]} - Kilomètres: ${maintenance["km"]}',
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MaintenanceDetailsPage(maintenance: maintenance),
                        ),
                      );
                    },
                  ),
                );
              },
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
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10.0),
          ),
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
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
