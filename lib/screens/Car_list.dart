
import 'package:my_app_car/screens/Add-page.dart';
import 'package:my_app_car/services/car_service.dart';
import 'package:my_app_car/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';

class CarListPage extends StatefulWidget {
  const CarListPage({Key? key}) : super(key: key);

  @override
  State<CarListPage> createState() => _CarListPageState();
}

class _CarListPageState extends State<CarListPage> {
  bool isLoding = false;
  List items = [];

  @override
  void initState() {
    super.initState();
    fetchCar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Car liste"),
      ),
      body: Visibility(
        visible: isLoding,
        child: Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: fetchCar,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text(
                'No Car Item',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            child: ListView.builder(
                itemCount: items.length,
                padding: EdgeInsets.all(9),
                itemBuilder: (context, index) {
                  final item = items[index] as Map;
                  final id = item['_id'] as String;
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      title: Text(item['Marque']),
                      subtitle: Text(item['Modéle']),
                      trailing: PopupMenuButton(
                        onSelected: (value) {
                          if (value == 'edit') {
                            navigateCarEditPage(item);
                          } else if (value == 'delete') {
                            deleteById(id);
                          }
                        },
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              child: Text('Edit'),
                              value: 'edit',
                            ),
                            PopupMenuItem(
                              child: Text('Delete'),
                              value: 'delete',
                            ),
                          ];
                        },
                      ),
                    ),
                  );
                }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: navigateCarAddPage, label: Text('Add Car')),
    );
  }

  Future<void> navigateCarEditPage(Map item) async {
    final route =
        MaterialPageRoute(builder: (context) => AddCarPage(todo: item));
    await Navigator.push(context, route);
    setState(() {
      isLoding = true;
    });
    fetchCar();
  }

  Future<void> navigateCarAddPage() async {
    final route = MaterialPageRoute(builder: (context) => AddCarPage());
    await Navigator.push(context, route);
    setState(() {
      isLoding = true;
    });
    fetchCar();
  }

  Future<void> deleteById(String id) async {
    final iSsuccess = await CarService.deleteById(id);
    if (iSsuccess) {
      final filtred = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtred;
      });
    } else {
      showErroMessage(context,message: "Deletion failed ");
    }
  }

  Future<void> fetchCar() async {
    final response = await CarService.fetchCar();
    if (response != null) {
      setState(() {
        items = response;
      });
    } else {
      showErroMessage(context, message:'Somthing went  wrong');
    }
    setState(() {
      isLoding = false;
    });
  }

  
}
