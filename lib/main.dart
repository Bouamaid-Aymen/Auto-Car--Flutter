import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';
import 'package:my_app_car/controller/splace_controller.dart';
import 'package:my_app_car/screens/ChatBot/const.dart';
import 'package:my_app_car/screens/splace_screen.dart';

void main() {
  // Replace GEMINI_API_KEY with your actual API key
  Gemini.init(apiKey: GEMINI_API_KEY);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SplaceController splaceController = Get.put(SplaceController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Auto Car',
       theme: ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    hintColor: Colors.blueAccent,
    // Autres configurations de thème si nécessaire
  ),
      home: Splash_Screen(),
    );
  }
}
