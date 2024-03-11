import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MaintenanceListPage extends StatefulWidget {
  @override
  _MaintenanceListPageState createState() => _MaintenanceListPageState();
}

class _MaintenanceListPageState extends State<MaintenanceListPage> {
  late List<dynamic> maintenanceList;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    const url = "http://localhost:3000/voiture/add";
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
        title: Text('Liste des maintenances'),
      ),
      body: maintenanceList == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: maintenanceList.length,
              itemBuilder: (context, index) {
                final maintenance = maintenanceList[index];
                return Card(
                  child: ListTile(
                    title: Text('Maintenance ${maintenance["id"]}'),
                    subtitle: Text('Date: ${maintenance["date"]} - Kilomètres: ${maintenance["km"]}'),
                    onTap: () {
                      // Ajouter ici la logique pour afficher les détails de la maintenance
                    },
                  ),
                );
              },
            ),
    );
  }
}
