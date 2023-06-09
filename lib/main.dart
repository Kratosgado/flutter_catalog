import 'package:flutter/material.dart';
import 'package:flutter_catalog/components/lists/expansion_tile.dart';
import 'package:flutter_catalog/components/lists/listwheel_scrollview.dart';
import 'package:flutter_catalog/components/lists/reorderable_list.dart';
import 'package:flutter_catalog/components/lists/swipe_dismiss.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Container(
            height: 100,
            color: Colors.deepPurple,
            alignment: Alignment.center,
            child: const Text(
              "Mbeah Catalog",
              style: TextStyle(
                color: Colors.white,
                fontSize: 50,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          )),
      body: const ListWheelViewExample(),
    );
  }
}
