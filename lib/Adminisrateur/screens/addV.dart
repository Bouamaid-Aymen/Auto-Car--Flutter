import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:my_app_car/utils/snackbar_helper.dart';

class AddDashboardLightPage extends StatefulWidget {
  @override
  _AddDashboardLightPageState createState() => _AddDashboardLightPageState();
}

class _AddDashboardLightPageState extends State<AddDashboardLightPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  File? _image;
  List<Voyant> voyants = [];

  @override
  void initState() {
    super.initState();
    fetchVoyants();
  }

  Future getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Dashboard Light'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'AJOUTER UN VOYANT',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            Divider(),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: getImage,
              child: Text('Select Image'),
            ),
            SizedBox(height: 20.0),
            _image == null ? Text('No image selected.') : Text(_image!.path),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: addV,
              child: Text('Add Dashboard Light'),
            ),
            SizedBox(height: 20.0),
            Text(
              'LISTE DES VOYANTS',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: voyants.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(voyants[index].nom),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        deleteVoyant(voyants[index].id);
                      },
                    ),
                    onTap: () {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addV() async {
    final name = nameController.text;
    final description = descriptionController.text;
    final imageName = _image != null ? _image!.path.split('/').last : '';
    final body = {"nom": name, "description": description, "image": imageName};
    final uri = Uri.parse("http://localhost:3000/car/voyant");
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    print(response.body);
    if (response.statusCode == 201) {
      showSuccessMessage(context, message: "Création validée");
      // Actualiser la liste des voyants après l'ajout
      fetchVoyants();
    } else {
      print(response.statusCode);
      showErroMessage(context, message: "Échec de la création");
    }
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

  Future<void> deleteVoyant(int id) async {
    final uri = Uri.parse('http://localhost:3000/car/$id/voyant');
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
  
      fetchVoyants();
      showSuccessMessage(context, message: 'Voyant supprimé avec succès');
    } else {
      
      print(response.body);
      showErroMessage(context, message: 'Échec de la suppression du voyant');
    }
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
