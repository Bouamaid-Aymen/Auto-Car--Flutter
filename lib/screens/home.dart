import 'package:flutter/material.dart';
import 'package:my_app_car/utils/NavBar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.notifications))
        ],
        backgroundColor: Theme.of(context).colorScheme.primary,
      title: Text('Auto-Car'),
      ),
      body: Center(),
    );
  }
}
class M extends StatefulWidget {
  const M({super.key});

  @override
  State<M> createState() => _MState();
}

class _MState extends State<M> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}