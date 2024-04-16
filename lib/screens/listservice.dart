import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app_car/screens/Car_list.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ServiceListUPage extends StatefulWidget {
  @override
  _ServiceListUPageState createState() => _ServiceListUPageState();
}

class _ServiceListUPageState extends State<ServiceListUPage> {
  List<dynamic> services = [];
  String selectedGovernorate = 'Tunis';
  String selectedCity = 'Tunis';
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchServices('');
  }

  Future<void> fetchServices(String query) async {
    final Uri uri = Uri.parse('http://localhost:3000/car/service');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> allServices = jsonDecode(response.body);

      setState(() {
        if (selectedGovernorate != 'Tunis' || selectedCity != 'Tunis') {
          services = allServices
              .where((service) =>
                  service['verifier'] == 'OUI' &&
                  service['gouvernorat'] == selectedGovernorate &&
                  service['ville'] == selectedCity &&
                  service['nomS'].toLowerCase().contains(query.toLowerCase()))
              .toList();
        } else {
          services = allServices
              .where((service) =>
                  service['verifier'] == 'OUI' &&
                  service['nomS'].toLowerCase().contains(query.toLowerCase()))
              .toList();
        }
      });
    } else {
      print('Failed to fetch services');
    }
  }

  @override
  Widget build(BuildContext context) {
    String username = TokenStorage.getUsername();
    String emailU = TokenStorage.getEmail();

    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text('Liste des services',
                style: TextStyle(color: Colors.blue))),
      ),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Rechercher un service...',
              hintStyle:
                  TextStyle(color: const Color.fromARGB(178, 158, 158, 158)),
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (query) {
              fetchServices(query);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DropdownButton<String>(
                value: selectedGovernorate,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedGovernorate = newValue!;
                    selectedCity = citiesByGovernorate[selectedGovernorate]![0];
                    fetchServices('');
                  });
                },
                items:
                    governorates.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              DropdownButton<String>(
                value: selectedCity,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCity = newValue!;
                    fetchServices('');
                  });
                },
                items: citiesByGovernorate[selectedGovernorate]!
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                return Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Nom de service: ',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                              ),
                              TextSpan(
                                text: '${service['nomS']}',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      ListTile(
                        title: Text(
                            'Nom et Prénom de personne: ${service['nomP']}'),
                      ),
                      ListTile(
                        title: Text('Téléphone: ${service['tel']}'),
                      ),
                      ListTile(
                        title: Text('Gouvernorat: ${service['gouvernorat']}'),
                      ),
                      ListTile(
                        title: Text('Ville: ${service['ville']}'),
                      ),
                      ListTile(
                        title: Text('Description: ${service['description']}'),
                      ),
                      ListTile(
                        title: GestureDetector(
                          onTap: () {
                            launchUrlString('${service['localisation']}');
                          },
                          child: Text(
                            'Localisation: ${service['localisation']}',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                      ListTile(
                        title: Row(
                          children: [
                            Text(
                              'Envoyer un message',
                              style: TextStyle(color: Colors.green),
                            ),
                            IconButton(
                              icon: Icon(Icons.message),
                              color: Color.fromARGB(255, 72, 0, 103),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                          'Envoyer un message ( Entrer votre numero pour contacter ) '),
                                      content: TextField(
                                        controller: messageController,
                                        decoration: InputDecoration(
                                          hintText:
                                              'Entrez votre message ici...',
                                        ),
                                        maxLines: null,
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('Envoyer'),
                                          onPressed: () {
                                            messageApi(
                                                username, service, emailU);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text('Annuler'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> messageApi(
      String username, Map<String, dynamic> service, String emailU) async {
    final message = messageController.text;
    final body = {
      "message": message,
      "usernameU": username,
      "email": service['email'],
      "nom_service": service['nomS'],
      "emailU": emailU
    };
    const url = "http://localhost:3000/users/message";
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Message envoyé avec succès'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Échec de l\'envoi du message'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

List<String> governorates = [
  'Tunis',
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
  'Béja': ['Béja', 'Testour', 'Medjez el-Bab', 'Nefza', 'Amdoun', 'Goubellat'],
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
  'Siliana': ['Siliana', 'Bouarada', 'Gaâfour', 'El Krib', 'Makthar', 'Rouhia'],
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
