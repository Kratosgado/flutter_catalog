import 'package:flutter/material.dart';

class WrapExample extends StatelessWidget {
  const WrapExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        children: ['Prince', 'Mbeah', 'Essilfie', 'Killcode', 'Jeff', 'Sarpong']
            .map((name) => Chip(
                  deleteIcon: Icon(Icons.cancel),
                  label: Text(name),
                  avatar: CircleAvatar(
                      backgroundColor: Colors.amber,
                      child: Text(
                        name.substring(0, 1),
                      )),
                ))
            .toList(),
      ),
    );
  }
}
