import 'package:flutter/material.dart';
import 'package:my_app_car/Service_Auto/screens/boiteM.dart';
import 'package:my_app_car/Service_Auto/screens/home_service.dart';
import 'package:my_app_car/screens/Car_list.dart';
import 'package:my_app_car/screens/login_page.dart';
import 'package:my_app_car/setting/setting.dart';

class NavBarS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String username = TokenStorage.getUsername();
    String email = TokenStorage.getEmail();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
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
                image: AssetImage("assets/images/serviceS.png"),
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
            leading: Icon(
              IconData(0xe1d7, fontFamily: 'MaterialIcons'),
            ),
            title: Text('Service'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ServiceListPage()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.message,
              color: Color.fromARGB(255, 56, 10, 220),
            ),
            title: Text('Boite de messagerie'),
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MessageListPage()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.account_circle, color: Colors.blue),
            title: Text('Compte'),
            onTap: () async {
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
            title: Text('Quiter'),
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
