import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';

class BackdropExample extends StatelessWidget {
  const BackdropExample({super.key});

  @override
  Widget build(BuildContext context) {
    return BackdropScaffold(
      appBar: BackdropAppBar(
        title: const Text('Backdrop demo'),
      ),
      headerHeight: 120,
      frontLayer: const Center(
        child: Text('(front layer) \n Click top right'),
      ),
      backLayer: const Center(child: Text('Back layer')),
    );
  }
}
