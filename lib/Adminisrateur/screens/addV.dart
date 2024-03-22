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
            _image == null ? Text('No image selected.') : Image.file(_image!),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: addV,
              child: Text('Add Dashboard Light'),
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
    } else {
      print(response.statusCode);
      showErroMessage(context, message: "Échec de la création");
    }
  }
}
