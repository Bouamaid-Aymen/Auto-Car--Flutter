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
  String? selectedCritique;

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
     fetchVoyants();
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Liste des voyants',
            style: TextStyle(color: Colors.white),
          ),
        ),
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
                color: Colors.blue,
              ),
            ),
            Divider(),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nom',
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
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Critique/Non Critique',
              ),
              value: selectedCritique,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCritique = newValue;
                });
              },
              items: <String>['Critique', 'Non Critique']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: getImage,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              child: Text('Sélectionnez une image'),
            ),
            SizedBox(height: 20.0),
            _image == null ? Text('No image selected.') : Text(_image!.path),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: addV,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
              ),
              child: Text('Ajouter voyant'),
            ),
            SizedBox(height: 20.0),
            Text(
              'LISTE DES VOYANTS',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: voyants.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(voyants[index].nom),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'Description',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  content: Text(voyants[index].description),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Fermer'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.info),
                          label: Text('Description'),
                        ),
                        Text(voyants[index].critique),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.orange,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditVoyantPage(voyants[index]),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            deleteVoyant(voyants[index].id);
                          },
                        ),
                      ],
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
    final critique = selectedCritique;
    final imageName = _image != null ? _image!.path.split('/').last : '';
    final body = {
      "nom": name,
      "description": description,
      "critique": critique,
      "image": imageName
    };
    final uri = Uri.parse("http://localhost:3000/car/voyant");
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    print(response.body);
    if (response.statusCode == 201) {
      showSuccessMessage(context, message: "Création validée");
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
    final confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Voulez-vous vraiment supprimer ce voyant ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Non'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Oui'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
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
}

class Voyant {
  final int id;
  final String nom;
  final String description;
  final String critique;
  final String image;

  Voyant({
    required this.id,
    required this.nom,
    required this.description,
    required this.critique,
    required this.image,
  });

  factory Voyant.fromJson(Map<String, dynamic> json) {
    return Voyant(
      id: json['id'],
      nom: json['nom'],
      description: json['description'],
      critique: json['critique'],
      image: json['image'],
    );
  }
}

class EditVoyantPage extends StatefulWidget {
  final Voyant voyant;

  EditVoyantPage(this.voyant);

  @override
  _EditVoyantPageState createState() => _EditVoyantPageState();
}

class _EditVoyantPageState extends State<EditVoyantPage> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  String? selectedCritique;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.voyant.nom);
    descriptionController =
        TextEditingController(text: widget.voyant.description);
    selectedCritique = widget.voyant.critique;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Voyant'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nom',
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
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Critique/Non Critique',
              ),
              value: selectedCritique,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCritique = newValue;
                });
              },
              items: <String>['Critique', 'Non Critique']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                updateVoyant(widget.voyant.id);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              child: Text('Mettre à jour'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateVoyant(int id) async {
    final name = nameController.text;
    final description = descriptionController.text;
    final critique = selectedCritique;
    final uri = Uri.parse('http://localhost:3000/car/$id/voyant');
    final body = jsonEncode({
      'nom': name,
      'description': description,
      'critique': critique,
    });
    final response = await http.patch(
      uri,
      body: body,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      Navigator.pop(context);
      showSuccessMessage(context, message: 'Voyant mis à jour avec succès');
    } else {
      showErroMessage(context, message: 'Échec de la mise à jour du voyant');
    }
  }
}
