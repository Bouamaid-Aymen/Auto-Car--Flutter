import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher_string.dart';

class ListeService extends StatefulWidget {
  @override
  _ListeServiceState createState() => _ListeServiceState();
}

class _ListeServiceState extends State<ListeService> {
  List<dynamic> services = [];
  List<dynamic> filteredServices = [];

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
        filteredServices = services;
      });
    } else {
      print('Failed to load services');
    }
  }

  Future<void> deleteService(int id) async {
    final url = Uri.parse('http://localhost:3000/car/$id/service');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Confirmation'),
          content: Text('Voulez-vous vraiment supprimer ce service ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                http.delete(url);
                fetchServices();
                Navigator.of(context).pop();
              },
              child: Text('Confirmer'),
            ),
          ],
        ),
      );
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
      print('Failed to verify service');
    }
  }

  void filterServices(String query) {
    setState(() {
      filteredServices = services
          .where((service) =>
              service['nomS'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          'Liste des Services',
        )),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: ServiceSearch(services, filterServices));
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredServices.length,
        itemBuilder: (context, index) {
          final service = filteredServices[index];
          return Card(
            //color: Colors.indigoAccent,
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service['nomP'],
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              service['nomS'],
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Text(
                    service['verifier'],
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                            Text('VÉRIFIÉ', style: TextStyle(color: Colors.green)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.info),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Détails du service'),
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text('Nom du service: ',
                                        style: TextStyle(color: Colors.blue)),
                                    Text('${service['nomS']}',
                                        style: TextStyle(color: Colors.grey)),
                                    SizedBox(height: 8), 
                                    Text('Email: ',
                                        style: TextStyle(color: Colors.blue)),
                                    Text('${service['email']}',
                                        style: TextStyle(color: Colors.grey)),
                                    SizedBox(height: 8), 
                                    Text('Nom: ',
                                        style: TextStyle(color: Colors.blue)),
                                    Text('${service['nomP']}',
                                        style: TextStyle(color: Colors.grey)),
                                    SizedBox(height: 8), 
                                    Text('Téléphone: ',
                                        style: TextStyle(color: Colors.blue)),
                                    Text('${service['tel']}',
                                        style: TextStyle(color: Colors.grey)),
                                    SizedBox(height: 8),
                                    Text('gouvernorat: ',
                                        style: TextStyle(color: Colors.blue)),
                                    Text('${service['gouvernorat']}',
                                        style: TextStyle(color: Colors.grey)),
                                    SizedBox(height: 8), 
                                    Text('ville: ',
                                        style: TextStyle(color: Colors.blue)),
                                    Text('${service['ville']}',
                                        style: TextStyle(color: Colors.grey)),
                                    SizedBox(height: 8), 
                                    Text('description: ',
                                        style: TextStyle(color: Colors.blue)),
                                    Text('${service['description']}',
                                        style: TextStyle(color: Colors.grey)),
                                    SizedBox(height: 8), 
                                    GestureDetector(
                                      onTap: () {
                                        launchUrlString(
                                            '${service['localisation']}');
                                      },
                                      child: Text('localisation: ',
                                          style: TextStyle(color: Colors.blue)),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        launchUrlString(
                                            '${service['localisation']}');
                                      },
                                      child: Text(
                                        '${service['localisation']}',
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 48, 0, 132),
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8), // Espacement
                                    Text('Vérifié: ',
                                        style: TextStyle(color: Colors.blue)),
                                    Text('${service['verifier']}',
                                        style: TextStyle(color: Colors.green)),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
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
                  Divider(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ServiceSearch extends SearchDelegate<String> {
  final List<dynamic> services;
  final Function(String) filterServices;

  ServiceSearch(this.services, this.filterServices);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          filterServices(query);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView(
      children: services
          .where((service) =>
              service['nomS'].toLowerCase().contains(query.toLowerCase()))
          .map((service) => ListTile(
                title: Text(service['nomS']),
                onTap: () {
                  filterServices(service['nomS']);
                  close(context, service['nomS']);
                },
              ))
          .toList(),
    );
  }
}
