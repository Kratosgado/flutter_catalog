import 'package:flutter/material.dart';

class ListViewBuilderExample extends StatelessWidget {
  const ListViewBuilderExample({super.key});

  @override
  Widget build(BuildContext context) {
    const numItems = 20;
    const biggerFont = TextStyle(fontSize: 18);

    Widget buildRow(int idx) {
      return ListTile(
        leading: CircleAvatar(
          child: Text("$idx"),
        ),
        title: Text('Item $idx', style: biggerFont),
        trailing: const Icon(Icons.dashboard),
      );
    }

    return ListView.builder(
      itemCount: numItems * 2,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, i) {
        if (i.isOdd) return const Divider();
        final index = i ~/ 2 + 1;
        return buildRow(index);
      },
    );
  }
}
