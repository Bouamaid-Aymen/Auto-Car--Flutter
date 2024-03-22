import 'package:flutter/material.dart';
import 'package:my_app_car/screens/Car_list.dart';
import 'package:my_app_car/screens/Dashboard_Lights.dart';
import 'package:my_app_car/screens/login_page.dart';
import 'package:my_app_car/screens/my_car.dart';
import 'package:my_app_car/setting/setting.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String username = TokenStorage.getUsername();
    String email = TokenStorage.getEmail();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(username),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              child: Icon(Icons.account_circle, size: 48.0),
            ),
          ),
          ListTile(
            leading: Icon(
              IconData(0xe1d7, fontFamily: 'MaterialIcons'),
            ),
            title: Text('My Car'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyCar()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.apps),
            title: Text('Dashboard Light'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserPage()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.emoji_objects),
            title: Text('Detect Together'),
            onTap: () => null,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('Location'),
            onTap: () => null,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.contact_support),
            title: Text('Setting'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Setting()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              IconData(0xe243, fontFamily: 'MaterialIcons'),
            ),
            title: Text('Exit'),
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
