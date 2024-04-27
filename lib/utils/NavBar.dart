import 'package:flutter/material.dart';
import 'package:my_app_car/screens/Car_list.dart';
import 'package:my_app_car/screens/ChatBot/searching.dart';
import 'package:my_app_car/screens/Dashboard_Lights.dart';
import 'package:my_app_car/screens/listservice.dart';
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
                image: AssetImage("assets/images/navBar.png"),
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
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              email,
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(IconData(0xe1d7, fontFamily: 'MaterialIcons'),
                color: Colors.blue),
            title: Text('Les Voitures'),
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
              'Les voyants',
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
              Icons.car_crash_rounded,
              color: Colors.blue,
            ),
            title: Text('Mon mécano'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatbotCar()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.list, color: Colors.blue),
            title: Text('Liste des services '),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ServiceListUPage()),
              );
            },
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
            leading: Icon(Icons.contact_emergency, color: Colors.blue),
            title: Text(
              'Contact',
            ),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(
              IconData(0xe243, fontFamily: 'MaterialIcons'),
              color: Colors.red,
            ),
            title: Text('Quitter'),
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
