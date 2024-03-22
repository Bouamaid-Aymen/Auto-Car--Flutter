import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<Voyant> voyants = [];

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
      });
    } else {
      throw Exception('Failed to load voyants');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page Utilisateur'),
      ),
      body: ListView.builder(
        itemCount: voyants.length,
        itemBuilder: (context, index) {
String imagePath = voyants[index].image.split('/').last;
List<String> parts = imagePath.split('\\');
String imageName = parts.last;
print(imageName); // Résultat : isi kef.png
          print(imageName);
          return ListTile(
            title: Text(voyants[index].nom),
            subtitle: Text(voyants[index].description),
            leading: Image.asset('assets/images/$imageName'),

          );
        },
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