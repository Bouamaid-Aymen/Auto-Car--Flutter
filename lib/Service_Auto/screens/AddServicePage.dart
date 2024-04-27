import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher_string.dart';

class AddServicePage extends StatefulWidget {
  @override
  _AddServicePageState createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  bool _obscureText = true;
  String selectedGovernorate = 'Governorate';
  String selectedCity = 'Ville';
  TextEditingController selectedGovernorateController = TextEditingController();
  TextEditingController selectedCityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedGovernorate = 'Governorate';
    selectedCity = 'Ville';
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController serviceNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController DescriptionController = TextEditingController();
  final TextEditingController localisationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Ajouter des services',
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nom *',
                prefixIcon: Icon(Icons.person, color: Colors.blue),
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email *',
                prefixIcon: Icon(Icons.email, color: Colors.blue),
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Mot de passe *',
                prefixIcon: Icon(Icons.lock, color: Colors.blue),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.blue,
                  ),
                  onPressed: _togglePasswordVisibility,
                ),
                labelStyle: TextStyle(color: Colors.white),
              ),
              obscureText: _obscureText,
            ),
            TextFormField(
              controller: phoneController,
              maxLength: 8,
              decoration: InputDecoration(
                labelText: 'Téléphone *',
                prefixIcon: Icon(Icons.phone, color: Colors.blue),
                labelStyle: TextStyle(color: Colors.white),
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez saisir votre numéro de téléphone';
                } else if (value.length != 8) {
                  return 'Le numéro de téléphone doit être composé de 8 chiffres';
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              value: selectedGovernorate,
              onChanged: (value) {
                setState(() {
                  selectedGovernorate = value!;
                  selectedCity = citiesByGovernorate[value]![0];
                  selectedGovernorateController.text = value;
                  selectedCityController.text = selectedCity;
                });
              },
              items: governorates.map((governorate) {
                return DropdownMenuItem<String>(
                  value: governorate,
                  child: Text(governorate),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Gouvernorat *',
                labelStyle: TextStyle(color: Colors.white),
                prefixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.maps_home_work, color: Colors.blue),
                    SizedBox(width: 8),
                  ],
                ),
              ),
            ),
            DropdownButtonFormField<String>(
              value: selectedCity,
              onChanged: (value) {
                setState(() {
                  selectedCity = value!;
                  selectedCityController.text = value;
                });
              },
              items: citiesByGovernorate[selectedGovernorate]!.map((city) {
                return DropdownMenuItem<String>(
                  value: city,
                  child: Text(city),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Ville *',
                prefixIcon: Icon(Icons.apartment_sharp, color: Colors.blue),
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
            TextField(
              controller: serviceNameController,
              decoration: InputDecoration(
                labelText: 'Service *',
                prefixIcon:
                    Icon(Icons.assignment_ind_sharp, color: Colors.blue),
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
            TextField(
              controller: DescriptionController,
              decoration: InputDecoration(
                labelText: 'Description *',
                prefixIcon: Icon(Icons.description, color: Colors.blue),
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
            TextField(
              controller: localisationController,
              decoration: InputDecoration(
                labelText: 'Localisation (lien google maps)',
                prefixIcon: Icon(Icons.map_rounded, color: Colors.blue),
                labelStyle: TextStyle(color: Colors.white),
              ),
              onTap: () {
                launchUrlString(
                    'https://www.google.com/maps/place/Tunisie/@34.6994618,7.6245676,7.34z/data=!4m6!3m5!1s0x125595448316a4e1:0x3a84333aaa019bef!8m2!3d33.886917!4d9.537499!16zL20vMDdmal8?entry=ttu');
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                addService();
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(1),
                backgroundColor: Colors.blue,
              ),
              child: Text(
                'Ajouter le service',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addService() async {
    const url = 'http://localhost:3000/car/service';
    final uri = Uri.parse(url);
    final email = emailController.text;
    final nom = serviceNameController.text;
    final nomP = nameController.text;
    final tel = phoneController.text;
    final password = passwordController.text;
    final governorate = selectedGovernorateController.text;
    final city = selectedCityController.text;
    final description = DescriptionController.text;
    final localisation = localisationController.text;
    final body = {
      'nomS': nom,
      'email': email,
      'nomP': nomP,
      'tel': tel,
      'gouvernorat': governorate,
      'ville': city,
      "password": password,
      'description': description,
      'localisation': localisation
    };

    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      Get.snackbar('succès', 'Service ajouté avec succès',
          backgroundColor: Colors.green, snackPosition: SnackPosition.BOTTOM);
    } else {
      print(response.statusCode);
      Get.snackbar('Échoué', 'Échec de l`ajout du service',
          backgroundColor: Colors.red, snackPosition: SnackPosition.BOTTOM);
    }
  }

  List<String> governorates = [
    'Governorate',
    'Ariana',
    'Ben Arous',
    'Manouba',
    'Nabeul',
    'Zaghouan',
    'Bizerte',
    'Béja',
    'Jendouba',
    'Le Kef',
    'Siliana',
    'Sousse',
    'Monastir',
    'Mahdia',
    'Sfax',
    'Kairouan',
    'Kasserine',
    'Sidi Bouzid',
    'Gabès',
    'Médenine',
    'Tataouine',
    'Gafsa'
  ];

  Map<String, List<String>> citiesByGovernorate = {
    'Governorate': ['Ville'],
    'Tunis': ['Tunis', 'Ariana', 'Ben Arous', 'Manouba'],
    'Ariana': ['Ariana', 'La Soukra', 'Raoued'],
    'Ben Arous': ['Ben Arous', 'Marsa', 'Hammam Lif'],
    'Manouba': ['Manouba', 'Oued Ellil', 'Douar Hicher'],
    'Nabeul': [
      'Nabeul',
      'Hammamet',
      'Kelibia',
      'Dar Chaabane',
      'Menzel Temime',
      'Soliman',
      'Korba',
      'Tazarka',
      'Béni Khiar',
      'El Maamoura'
    ],
    'Zaghouan': ['Zaghouan', 'Zriba', 'Fahs'],
    'Bizerte': [
      'Bizerte',
      'Menzel Bourguiba',
      'Mateur',
      'Ras Jebel',
      'Sejnane',
      'Tinja'
    ],
    'Béja': [
      'Béja',
      'Testour',
      'Medjez el-Bab',
      'Nefza',
      'Amdoun',
      'Goubellat'
    ],
    'Jendouba': [
      'Jendouba',
      'Tabarka',
      'Aïn Draham',
      'Fernana',
      'Ghardimaou',
      'Oued Melliz',
      'Bou Salem'
    ],
    'Le Kef': [
      'Le Kef',
      'Dahmani',
      'Tajerouine',
      'Sakiet Sidi Youssef',
      'Nebeur',
      'Kalâat Sinane',
      'Jérissa'
    ],
    'Siliana': [
      'Siliana',
      'Bouarada',
      'Gaâfour',
      'El Krib',
      'Makthar',
      'Rouhia'
    ],
    'Sousse': [
      'Sousse',
      'Monastir',
      'M\'saken',
      'Kalâa Kebira',
      'Kalâa Seghira',
      'Akouda',
      'Ezzouhour',
      'Hergla',
      'Kondar',
      'Sidi Bou Ali',
      'Sidi El Hani',
      'Enfidha'
    ],
    'Monastir': [
      'Monastir',
      'Kairouan',
      'Mahdia',
      'Moknine',
      'Bekalta',
      'Teboulba',
      'Sayada',
      'Bembla',
      'Ksibet Thrayet',
      'Sahline',
      'Zéramdine'
    ],
    'Mahdia': [
      'Mahdia',
      'Bou Merdès',
      'Chebba',
      'El Jem',
      'Kerker',
      'Rejiche',
      'Sidi Alouane',
      'Chorbane',
      'Essouassi'
    ],
    'Sfax': [
      'Sfax',
      'Sakiet Ezzit',
      'Menzel Chaker',
      'El Amra',
      'Ghraiba',
      'Agareb',
      'Thyna',
      'Jebeniana',
      'Skhira',
      'Mahares',
      'Kerkennah'
    ],
    'Kairouan': [
      'Kairouan',
      'Oueslatia',
      'Hajeb El Ayoun',
      'Nasrallah',
      'Sbikha',
      'Chrarda',
      'Bouhajla',
      'Nouvelle Matmata'
    ],
    'Kasserine': [
      'Kasserine',
      'Sbeitla',
      'Fériana',
      'Thala',
      'Majel Bel Abbès',
      'Hassi El Ferid',
      'Ezzouhour'
    ],
    'Sidi Bouzid': [
      'Sidi Bouzid',
      'Menzel Bouzaiane',
      'Jilma',
      'Cebbala Ouled Asker',
      'Souk Jedid',
      'Menzel El Khair',
      'Meknassy',
      'Regueb',
      'Ouled Haffouz'
    ],
    'Gabès': [
      'Gabès',
      'Mareth',
      'Métouia',
      'Ghannouch',
      'Matmata',
      'Nouvelle Matmata',
      'El Hamma',
      'El Metouia',
      'Oudhref',
      'Zarat',
      'Menzel El Habib'
    ],
    'Médenine': [
      'Médenine',
      'Ben Gardane',
      'Zarzis',
      'Djerba Houmt Souk',
      'Djerba Midoun',
      'Djerba Ajim',
      'Sidi Makhlouf',
      'Béni Khedache'
    ],
    'Tataouine': [
      'Tataouine',
      'Ghomrassen',
      'Bir Lahmar',
      'Dhehiba',
      'Remada',
      'Tataouine Sud'
    ],
    'Gafsa': [
      'Gafsa',
      'Métlaoui',
      'Redeyef',
      'El Guettar',
      'Moulares',
      'Belkhir',
      'Om Larayes',
      'Sened',
      'Sidi Aïch',
      'Mdhilla'
    ]
  };
}
