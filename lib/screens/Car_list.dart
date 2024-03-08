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

  static Future<void> storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}

class _CarListPageState extends State<CarListPage> {
  bool isloding = true;
  List items = [];

  @override
  void initState() {
    super.initState();
    fetchCar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.notifications))
        ],
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text('Auto-Car'),
      ),
      body: Visibility(
        visible: isloding,
        child: Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: fetchCar,
          child: ListView.builder(
            itemCount: items.length,
            padding: EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final item = items[index] as Map;
              final id = '${item['Id']}';

              return Card(
                child: ListTile(
                  leading: Icon(Icons.directions_car),
                  title: Text('${item['brand']} ${item['model']}'),
                  subtitle: Text(
                      'Age: ${item['age']} ans, KM: ${item['km']}, Dernière vidange: ${item['lastOilChangeDate']}'),
                  trailing: PopupMenuButton(onSelected: (value) {
                    if (value == 'edit') {
                      navigateToEditCarPage(item);
                    } else if (value == 'delete') {
                      deleteById(id);
                    } 
                  }, itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: Text('EDIT'),
                        value: 'edit',
                      ),
                      PopupMenuItem(
                        child: Text('DELETE'),
                        value: 'delete',
                        
                      ),
                      PopupMenuItem(
                        child: Text('CAHIER DE MAINTENANCE '),
                        value: 'maintenace ',
                        onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CarMaintenancePage()),
              );
            },
                      ),
                    ];
                  }),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> navigateTo() async {
    final route = MaterialPageRoute(builder: (context) => CarMaintenancePage());
    await Navigator.push(context, route);
  }

  Future<void> navigateToEditCarPage(Map item) async {
    final route = MaterialPageRoute(builder: (context) => MyCar(car: item));
    await Navigator.push(context, route);
    setState(() {
      isloding = true;
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
      showErroMessage(context, message: 'Somthing went Wrong');
    }
    setState(() {
      isloding = false;
    });
  }

  Future<void> deleteById(id) async {
    final isSuccess = await CarService.deleteBycar(id);
    if (isSuccess) {
      final filtred = items.where((element) => element['Id'] != id).toList();
      setState(() {
        items = filtred;
      });
    } else {
      showErroMessage(context, message: "Deletion failed ");
    }
  }
}
