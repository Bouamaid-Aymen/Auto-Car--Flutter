import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListeService extends StatefulWidget {
  @override
  _ListeServiceState createState() => _ListeServiceState();
}

class _ListeServiceState extends State<ListeService> {
  List<dynamic> services = [];

  @override
  void initState() {
    super.initState();
    fetchServices();
  }

  Future<void> fetchServices() async {
    final url = Uri.parse('http://localhost:3000/car/service');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        services = jsonDecode(response.body);
      });
    } else {
      print('Failed to load services');
    }
  }

  Future<void> deleteService(int id) async {
    final url = Uri.parse('http://localhost:3000/car/$id/service');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      fetchServices();
    } else {
      print('Failed to delete service');
    }
  }

  Future<void> verifyService(int id) async {
    final url = Uri.parse('http://localhost:3000/car/$id/service');
    final response = await http.patch(url);

    if (response.statusCode == 200) {
      fetchServices();
    } else {
      print('Failed to delete service');
    }

  }
  Future<void> verifyServiceN(int id) async {
    final url = Uri.parse('http://localhost:3000/car/$id/serviceN');
    final response = await http.patch(url);

    if (response.statusCode == 200) {
      fetchServices();
    } else {
      print('Failed to delete service');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Center(child: Text('Liste des Services')),
      ),
      body: ListView.builder(
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfo('Email', service['email']),
                  _buildInfo('Nom', service['nomP']),
                  _buildInfo('Nom du service', service['nomS']),
                  _buildInfo('Téléphone', service['tel'].toString()),
                  _buildInfo('Adresse', service['adress']),
                  _buildInfo('Vérifié', service['verifier'],
                      isVerification: true),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => deleteService(service['id']),
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            SizedBox(width: 8),
                            Text('Supprimer',
                                style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      TextButton(
                        onPressed: () => verifyService(service['id']),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check,
                              color: Colors.green,
                            ),
                            SizedBox(width: 8),
                            Text('OUI',
                                style: TextStyle(color: Colors.green)),
                          ],
                        ),
                      ),
                       TextButton(
                        onPressed: () => verifyServiceN(service['id']),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check,
                              color: Colors.redAccent,
                            ),
                            SizedBox(width: 8),
                            Text('NON',
                                style: TextStyle(color: Colors.redAccent)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfo(String title, String value, {bool isVerification = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(color: isVerification ? Colors.green : Colors.white),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}
