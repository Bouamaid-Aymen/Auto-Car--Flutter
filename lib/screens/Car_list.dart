import 'package:flutter/material.dart';
import 'package:my_app_car/screens/maintenance.dart';
import 'package:my_app_car/screens/my_car.dart';
import 'package:my_app_car/services/car_service.dart';
import 'package:my_app_car/utils/NavBar.dart';
import 'package:my_app_car/utils/snackbar_helper.dart';

import 'package:shared_preferences/shared_preferences.dart';

class CarListPage extends StatefulWidget {
  const CarListPage({Key? key}) : super(key: key);

  @override
  State<CarListPage> createState() => _CarListPageState();
}

class TokenStorage {
  static const String _tokenKey = 'token';
  static late String _username = 'username';
  static late String _email = 'email';

  static Future<void> storeToken(
      String token, String username, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    _username = username;
    _email = email;
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static String getUsername() {
    return _username;
  }

  static String getEmail() {
    return _email;
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}

class _CarListPageState extends State<CarListPage> {
  bool isLoading = true;
  List items = [];

  @override
  void initState() {
    super.initState();
    fetchCar();
  }

  @override
  Widget build(BuildContext context) {
    fetchCar();
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        backgroundColor: (const Color.fromARGB(0, 33, 149, 243)),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.notifications))
        ],
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 8),
              Text(
                'Liste des voitures ',
              ),
              Icon(Icons.content_paste_rounded, color: Colors.white)
            ],
          ),
        ),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: fetchCar,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/garage.avif'),
                fit: BoxFit.cover,
              ),
            ),
            child: ListView.builder(
              itemCount: items.length,
              padding: EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                final id = '${item['Id']}';

                return Card(
                  child: ListTile(
                    leading: Icon(Icons.directions_car, color: Colors.blue),
                    title: Text(
                      '${item['brand']} ${item['model']}',
                      style: TextStyle(color: Colors.blue),
                    ),
                    subtitle: Text(
                      'Age: ${item['age']} ans, KM: ${item['km']}, Dernière vidange: ${item['lastOilChangeDate']}',
                    ),
                    trailing: PopupMenuButton(
                      onSelected: (value) {
                        if (value == 'edit') {
                          navigateToEditCarPage(item);
                        } else if (value == 'delete') {
                          deleteById(id);
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            child: Row(
                              children: [
                                Icon(Icons.edit, color: Colors.blue),
                                SizedBox(width: 8),
                                Text(
                                  'MODIFIER',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ],
                            ),
                            value: 'edit',
                          ),
                          PopupMenuItem(
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: Colors.red),
                                SizedBox(width: 8),
                                Text(
                                  'SUPPRIMER',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                            value: 'delete',
                          ),
                          PopupMenuItem(
                            child: Row(
                              children: [
                                Icon(Icons.build, color: Colors.green),
                                SizedBox(width: 8),
                                Text(
                                  'CAHIER DE MAINTENANCE ',
                                  style: TextStyle(color: Colors.green),
                                ),
                              ],
                            ),
                            value: 'maintenance',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CarMaintenancePage(
                                    carId: id, // Passer l'ID de la voiture
                                  ),
                                ),
                              );
                            },
                          ),
                        ];
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> navigateToEditCarPage(Map item) async {
    final route = MaterialPageRoute(builder: (context) => MyCar(car: item));
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchCar();
  }

  Future<void> fetchCar() async {
    final response = await CarService.fetchcar();
    if (response != null) {
      setState(() {
        items = response;
      });
    } else {
      showErroMessage(context, message: 'Something went wrong');
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteById(id) async {
    final isSuccess = await CarService.deleteBycar(id);
    if (isSuccess) {
      showSuccessMessage(context, message: "Deletion success");
      final filtred = items.where((element) => element['Id'] != id).toList();
      setState(() {
        items = filtred;
      });
    } else {
      showErroMessage(context, message: "Deletion failed ");
    }
  }
}
