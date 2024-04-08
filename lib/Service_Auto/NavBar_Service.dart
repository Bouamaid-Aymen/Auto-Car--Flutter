import 'package:flutter/material.dart';
import 'package:my_app_car/Service_Auto/screens/home_service.dart';
import 'package:my_app_car/screens/Car_list.dart';
import 'package:my_app_car/screens/login_page.dart';


class NavBarS extends StatelessWidget {
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
              child: Icon(
                Icons.account_circle,
                size: 60,
                color: Colors.blueGrey,
              ),
              backgroundColor: Colors.blue,
            ),
            decoration: BoxDecoration(
              color: Colors.blueGrey, 
            ),
          ),
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
