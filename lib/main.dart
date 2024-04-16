import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';
import 'package:my_app_car/screens/ChatBot/const.dart';
import 'package:my_app_car/screens/splace_screen.dart';

void main() {
  
  Gemini.init(apiKey: GEMINI_API_KEY);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Auto Car',
       theme: ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    hintColor: Colors.blueAccent,
  
  ),
      home: Splash_Screen(),
    );
  }
}
