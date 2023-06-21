import 'package:flutter/material.dart';

class ListWheelViewExample extends StatefulWidget {
  const ListWheelViewExample({super.key});

  @override
  State<ListWheelViewExample> createState() => _ListWheelViewExampleState();
}

class _ListWheelViewExampleState extends State<ListWheelViewExample> {
  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView.useDelegate(
      itemExtent: 75,
      childDelegate: ListWheelChildBuilderDelegate(
        builder: (context, index) {
          if (index < 0 || index > 8) {
            return null;
          }
          return ListTile(
            leading: Text(
              '$index',
              style: TextStyle(fontSize: 50),
            ),
            title: Text('Tile $index'),
            subtitle: Text('Description here'),
          );
        },
      ),
    );
  }
}
