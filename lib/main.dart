import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app_car/controller/splace_controller.dart';
import 'package:my_app_car/screens/Car_list.dart';
import 'package:my_app_car/screens/login_page.dart';
import 'package:my_app_car/screens/splace_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SplaceController splaceController = Get.put(SplaceController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Auto CAr',
      
      theme: ThemeData(useMaterial3: true),
      home: const Splace_Screen(),
    );
  }
}
