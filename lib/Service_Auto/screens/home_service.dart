import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:my_app_car/Service_Auto/NavBar_Service.dart';
import 'package:my_app_car/screens/Car_list.dart';


class ServiceListPage extends StatefulWidget {
  @override
  _ServiceListPageState createState() => _ServiceListPageState();
}

class _ServiceListPageState extends State<ServiceListPage> {
  List<dynamic> services = [];

  @override
  void initState() {
    super.initState();
    fetchServices();
  }

  Future<void> fetchServices() async {
    final String email = TokenStorage.getEmail();

    final Uri uri = Uri.parse('http://localhost:3000/car/service');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> allServices = jsonDecode(response.body);
      setState(() {
        services = allServices
            .where((service) =>
                service['email'].toLowerCase() == email.toLowerCase())
            .toList();
      });
    } else {
      print('Failed to fetch services');
    }
  }

  @override
  Widget build(BuildContext context) {
    fetchServices();
    return Scaffold(
      drawer: NavBarS(),
      appBar: AppBar(
        title: Center(child: Text('')),
      ),
      body: ListView.builder(
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Liste des services',
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                ListTile(
                  title: RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Nom de service: ',
                          style: TextStyle(color: Colors.blue),
                        ),
                        TextSpan(
                          text: service['nomS'],
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditServicePage(
                          serviceId: service['id'],
                          fieldName: 'nomS',
                          fieldValue: service['nomS'],
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Nom et Prénom de personne: ',
                          style: TextStyle(color: Colors.blue),
                        ),
                        TextSpan(
                          text: service['nomP'],
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditServicePage(
                          serviceId: service['id'],
                          fieldName: 'nomP',
                          fieldValue: service['nomP'],
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Téléphone: ',
                          style: TextStyle(color: Colors.blue),
                        ),
                        TextSpan(
                          text: service['tel'].toString(),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditServicePage(
                          serviceId: service['id'],
                          fieldName: 'tel',
                          fieldValue: service['tel'].toString(),
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Adresse: ',
                          style: TextStyle(color: Colors.blue),
                        ),
                        TextSpan(
                          text: service['adress'],
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditServicePage(
                          serviceId: service['id'],
                          fieldName: 'adress',
                          fieldValue: service['adress'],
                        ),
                      ),
                    );
                  },
                ),
                Center(
                  child: ListTile(
                    title: RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Vérifié: ',
                            style: TextStyle(color: Colors.green),
                          ),
                          TextSpan(
                            text: service['verifier'],
                          ),
                        ],
                      ),
                    ),
                    
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class EditServicePage extends StatefulWidget {
  final int serviceId;
  final String fieldName;
  final String fieldValue;

  const EditServicePage({
    Key? key,
    required this.serviceId,
    required this.fieldName,
    required this.fieldValue,
  }) : super(key: key);

  @override
  _EditServicePageState createState() => _EditServicePageState();
}

class _EditServicePageState extends State<EditServicePage> {
  late String newValue;

  @override
  void initState() {
    super.initState();
    newValue = widget.fieldValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier les services'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'Valeur actuelle: ',
                    style: TextStyle(color: Colors.green),
                  ),
                  TextSpan(
                    text: widget.fieldValue,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    newValue = value;
                  });
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Nouvelle valeur',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                modifierService();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
              ),
              child: Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> modifierService() async {
    final url = 'http://localhost:3000/car/${widget.serviceId}/Modifier';
    final uri = Uri.parse(url);
    final response = await http.patch(
      uri,
      body: {
        widget.fieldName: newValue,
      },
    );
    if (response.statusCode == 200) {
      Get.snackbar('Succès ', 'Modification avec succèsr ',
          backgroundColor: Colors.green, snackPosition: SnackPosition.BOTTOM);
      Navigator.pop(context);
    } else {
      Get.snackbar('échouer ', 'échouer la modification  ',
          backgroundColor: Colors.red, snackPosition: SnackPosition.BOTTOM);
    }
  }
}
