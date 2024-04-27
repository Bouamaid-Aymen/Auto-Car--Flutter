import 'package:flutter/material.dart';
import 'package:my_app_car/Adminisrateur/screens/Cars.dart';
import 'package:my_app_car/Adminisrateur/screens/addV.dart';
import 'package:my_app_car/Adminisrateur/screens/listeuser.dart';
import 'package:my_app_car/Adminisrateur/screens/servicelist.dart';
import 'package:my_app_car/screens/Car_list.dart';
import 'package:my_app_car/screens/login_page.dart';

class NavBarAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String username = TokenStorage.getUsername();
    String email = TokenStorage.getEmail();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(""),
                Text(""),
              ],
            ),
            accountEmail: null,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/adminBc-a.png"),
                fit: BoxFit.cover,
              ),
            ),
            currentAccountPictureSize: Size(100.0, 100.0),
          ),
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.account_circle, color: Colors.white, size: 36),
              backgroundColor: const Color.fromARGB(0, 158, 158, 158),
            ),
            title: Text(
              username,
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              email,
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              IconData(0xe1d7, fontFamily: 'MaterialIcons'),
            ),
            title: Text(
              'Garage',
              style: TextStyle(color: Colors.blue),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DropdownScreen()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.apps_outlined),
            title: Text(
              'Liste des Utilisateurs ',
              style: TextStyle(color: Colors.blue),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => userListPage()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.assignment_outlined),
            title: Text(
              'Voyant ',
              style: TextStyle(color: Colors.blue),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddDashboardLightPage()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.list),
            title: Text(
              'List des services  ',
              style: TextStyle(color: Colors.blue),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ListeService()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              color: Colors.red,
              IconData(
                0xe243,
                fontFamily: 'MaterialIcons',
              ),
            ),
            title: Text(
              'Quitter',
              style: TextStyle(color: Colors.blue),
            ),
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
