import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app_car/controller/splace_controller.dart';
import 'package:my_app_car/screens/splace_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SplaceController splaceController = Get.put(SplaceController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Auto Car',
      theme: ThemeData.dark().copyWith(
        textTheme: ThemeData.dark().textTheme.apply(
              bodyColor: Colors.white, // Couleur de texte blanc
              displayColor: Color.fromARGB(255, 0, 95, 237), // Couleur de texte blanc pour les gros titres
            ),
      ),
      home: Splash_Screen(),
    );
  }
}
