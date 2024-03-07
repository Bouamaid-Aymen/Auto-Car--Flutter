import 'package:flutter/material.dart';
import 'package:my_app_car/screens/Dashboard_Lights.dart';
import 'package:my_app_car/screens/login_page.dart';
import 'package:my_app_car/screens/my_car.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
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
                MaterialPageRoute(
                    builder: (context) => DashboardLightsPage(
                          selectedBrand: "dfsfsf",
                          selectedModel: 'fdsfs',
                        )),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.emoji_objects),
            title: Text('Detect Toghether'),
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
            title: Text('About'),
            onTap: () => null,
          ),
          Divider(),
          ListTile(
            leading: Icon(
              IconData(0xe243, fontFamily: 'MaterialIcons'),
            ),
            title: Text('Exite'),
            onTap: () {
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
