import 'package:flutter/material.dart';
import 'package:my_app_car/services/car_service.dart';
import 'package:my_app_car/utils/NavBarAdmin.dart';
import 'package:my_app_car/utils/snackbar_helper.dart';

class userListPage extends StatefulWidget {
  const userListPage({Key? key}) : super(key: key);

  @override
  State<userListPage> createState() => _userListPageState();
}

class _userListPageState extends State<userListPage> {
  bool isLoading = true;
  List items = [];
  List filteredItems = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchuser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBarAdmin(),
      appBar: AppBar(
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 8),
              Text(
                'Liste des utilisateurs ',
                style: TextStyle(color: Colors.white),
              ),
              Icon(Icons.content_paste_rounded, color: Colors.grey)
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                filteredItems = items;
                searchController.clear();
              });
            },
            icon: Icon(Icons.clear),
          ),
        ],
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: fetchuser,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: "Rechercher par rôle ou nom",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      filteredItems = items.where((item) =>
                          (item['role'] as String)
                              .toLowerCase()
                              .contains(value.toLowerCase()) ||
                          (item['username'] as String)
                              .toLowerCase()
                              .contains(value.toLowerCase())).toList();
                    });
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredItems.length,
                  padding: EdgeInsets.all(12),
                  itemBuilder: (context, index) {
                    final item = filteredItems[index] as Map;
                    final id = '${item['id']}';

                    return Card(
                      child: ListTile(
                        leading: Icon(Icons.account_circle_sharp, color: Colors.blue),
                        title: Text(
                          'Username:${item['username']}      Email : ${item['email']}',
                          style: TextStyle(color: Colors.blue),
                        ),
                        subtitle: Text('    Role: ${item['role']}'),
                        trailing: PopupMenuButton(onSelected: (value) {
                          if (value == 'delete') {
                            deleteById(id);
                          }
                        }, itemBuilder: (context) {
                          return [
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
                          ];
                        }),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchuser() async {
    final response = await CarService.fetchuser();
    if (response != null) {
      setState(() {
        items = response;
        filteredItems = items;
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
          content: Text("Êtes-vous sûr de vouloir supprimer cet utilisateur ?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("Oui"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("Non"),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      final isSuccess = await CarService.deleteByuser(id);
      if (isSuccess) {
        final filtered = items.where((element) => element['id'] != id).toList();
        setState(() {
          items = filtered;
          filteredItems = items;
        });
      } else {
        showErroMessage(context, message: "La suppression a échoué");
      }
    }
  }
}
