import 'package:flutter/material.dart';
import 'package:backdrop/backdrop.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BackdropScaffold(
      backLayer: const Center(
        child: Text('BackLayer'),
      ),
      frontLayer: const Center(child: Text("Front Layer")),
    );
  }
}
