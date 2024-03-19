import 'package:flutter/material.dart';
import 'package:my_app_car/Adminisrateur/screens/Cars.dart';
import 'package:my_app_car/Adminisrateur/screens/listeuser.dart';
import 'package:my_app_car/screens/login_page.dart';

class NavBarAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("ADMIN"),
            accountEmail: Text(""),
            currentAccountPicture: CircleAvatar(
              child: Icon(Icons.account_circle, size: 48.0),
            ),
          ),
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
            leading: Icon(Icons.assignment_outlined),
            title: Text(
              'USERS ',
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
            leading: Icon(
              color: Colors.red,
              IconData(
                0xe243,
                fontFamily: 'MaterialIcons',
              ),
            ),
            title: Text(
              'Exite',
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