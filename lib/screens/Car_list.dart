import 'package:flutter/material.dart';
import 'package:my_app_car/screens/listeMain.dart';
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
        backgroundColor: const Color.fromARGB(143, 158, 158, 158),
        centerTitle: true,
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Auto ',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Car',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/listecar.jpg"),
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        child: Visibility(
          visible: isLoading,
          child: Center(child: CircularProgressIndicator()),
          replacement: RefreshIndicator(
            onRefresh: fetchCar,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '       Liste des mes voitures',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      padding: EdgeInsets.all(12),
                      itemBuilder: (context, index) {
                        final item = items[index] as Map;
                        final id = '${item['Id']}';
        
                        return Card(
                          child: ListTile(
                            leading: Icon(Icons.directions_car,
                                color: Color.fromARGB(255, 133, 1, 1)),
                            title: Text(
                              '${item['brand']} ${item['model']}:',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Text(
                              'Age: ${item['age']} ans      KM: ${item['km']}',
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
                                          builder: (context) =>
                                              MaintenanceListPage(
                                            carId: id,
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
                ],
              ),
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
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("Voulez-vous vraiment supprimer cet élément ?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("Annuler"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("Confirmer"),
            ),
          ],
        );
      },
    );

    if (confirmDelete == null || !confirmDelete) {
      return;
    }

    final isSuccess = await CarService.deleteBycar(id);
    if (isSuccess) {
      showSuccessMessage(context, message: "Succès de la suppression");
      final filtred = items.where((element) => element['Id'] != id).toList();
      setState(() {
        items = filtred;
      });
    } else {
      showErroMessage(context, message: "La suppression a échoué ");
    }
  }
}
