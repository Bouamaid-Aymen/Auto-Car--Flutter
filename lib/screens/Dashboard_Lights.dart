import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<Voyant> voyants = [];
  List<Voyant> filteredVoyants = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchVoyants();
  }

  Future<void> fetchVoyants() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/car/voyant'));
    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      setState(() {
        voyants = responseData.map((data) => Voyant.fromJson(data)).toList();
        filteredVoyants = voyants;
      });
    } else {
      throw Exception('Failed to load voyants');
    }
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
            
            
              Text(
                'Liste des voyants',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Chercher par nom',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  filteredVoyants = voyants
                      .where((voyant) => voyant.nom
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                      .toList();
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredVoyants.length,
              itemBuilder: (context, index) {
                String imagePath = filteredVoyants[index].image.split('/').last;
                List<String> parts = imagePath.split('\\');
                String imageName = parts.last;

                return Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        filteredVoyants[index].nom,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(filteredVoyants[index].description),
                      leading: Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/images/$imageName'),
                          ),
                        ),
                      ),
                    ),
                    Divider(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Voyant {
  final int id;
  final String nom;
  final String description;
  final String image;

  Voyant({
    required this.id,
    required this.nom,
    required this.description,
    required this.image,
  });

  factory Voyant.fromJson(Map<String, dynamic> json) {
    return Voyant(
      id: json['id'],
      nom: json['nom'],
      description: json['description'],
      image: json['image'],
    );
  }
}
