import 'package:flutter/material.dart';
import 'package:my_app_car/screens/Car_list.dart';
import 'package:my_app_car/screens/ChatBot/searching.dart';
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
            accountName: Text(
              username,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              email,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            currentAccountPicture: CircleAvatar(
              child: Icon(
                Icons.account_circle,
                size: 60,
                color: Colors.blueGrey,
              ),
              backgroundColor: Colors.grey,
            ),
            decoration: BoxDecoration(
              color: Colors.blueGrey, // Couleur de fond bleue
            ),
          ),
          ListTile(
            leading: Icon(IconData(0xe1d7, fontFamily: 'MaterialIcons'),
                color: Colors.blue),
            title: Text('Voitures'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyCar()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.warning, color: Colors.blue),
            title: Text(
              'LES VOYANTS',
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserPage()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.chat_bubble,
              color: Colors.blue,
            ),
            title: Text('CHAT BOT'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatbotCar()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.location_on, color: Colors.blue),
            title: Text('CARTE'),
            onTap: () => null,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.grey),
            title: Text('Paramètre'),
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
              color: Colors.red,
            ),
            title: Text('Sortie'),
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
