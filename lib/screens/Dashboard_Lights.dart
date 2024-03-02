import 'package:flutter/material.dart';

class DashboardLightsPage extends StatelessWidget {
  final String selectedBrand;
  final String selectedModel;

  DashboardLightsPage({required this.selectedBrand, required this.selectedModel});

  List<String> dashboardLights = [
    'Engine Light',
    'Oil Pressure Light',
    'Battery Light',
    'Brake System Light',
    'ABS Light',
    'Airbag Light',
    'Check Engine Light',
    'Traction Control Light',
  ];

  Map<String, String> lightImages = {
    'Engine Light': 'assets/engine_light.png',
    'Oil Pressure Light': 'assets/oil_light.png',
    'Battery Light': 'assets/battery_light.png',
    'Brake System Light': 'assets/brake_light.png',
    'ABS Light': 'assets/abs_light.png',
    'Airbag Light': 'assets/airbag_light.png',
    'Check Engine Light': 'assets/check_engine_light.png',
    'Traction Control Light': 'assets/traction_light.png',
  };

  Map<String, List<String>> causes = {
    'Engine Light': [
      'Loose or damaged gas cap',
      'Faulty oxygen sensor',
      'Faulty spark plugs or wires',
      'Faulty catalytic converter',
    ],
    'Oil Pressure Light': [
      'Low oil level',
      'Faulty oil pump',
      'Oil pressure sensor malfunction',
    ],
    'Battery Light': [
      'Dead battery',
      'Faulty alternator',
      'Loose or corroded battery connections',
    ],
    'Brake System Light': [
      'Low brake fluid',
      'Worn brake pads',
      'Brake system leak',
    ],
    'ABS Light': [
      'Faulty ABS sensor',
      'Low brake fluid',
      'Wiring issues',
    ],
    'Airbag Light': [
      'Faulty airbag module',
      'Faulty sensor',
      'Wiring issues',
    ],
    'Check Engine Light': [
      'Faulty oxygen sensor',
      'Loose or damaged gas cap',
      'Faulty catalytic converter',
      'Faulty mass airflow sensor',
    ],
    'Traction Control Light': [
      'Faulty wheel speed sensors',
      'Worn or damaged tires',
      'Faulty traction control module',
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Lights - $selectedBrand $selectedModel'),
      ),
      body: ListView.builder(
        itemCount: dashboardLights.length,
        itemBuilder: (context, index) {
          String light = dashboardLights[index];
          List<String> lightCauses = causes[light] ?? [];
          String imageAsset = lightImages[light] ?? '';

          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(imageAsset),
                radius: 20,
              ),
              title: Text(light),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: lightCauses.map((cause) {
                  return Text(cause);
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
