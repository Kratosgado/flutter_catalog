import 'package:flutter/material.dart';

class ReorderableListExample extends StatefulWidget {
  const ReorderableListExample({super.key});

  @override
  State<ReorderableListExample> createState() => _ReorderableListExampleState();
}

class _ReorderableListExampleState extends State<ReorderableListExample> {
  bool reverseSort = false;
  final List<String> items = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('').toList();

  void onReorder(int oldIndex, int newIndex) {
    setState(() {
      final newIdx = newIndex > oldIndex ? newIndex - 1 : newIndex;
      final item = items.removeAt(oldIndex);
      items.insert(newIdx, item);
    });
  }

  void onSort() {
    setState(() {
      reverseSort = !reverseSort;
      items.sort((a, b) => reverseSort ? b.compareTo(a) : a.compareTo(b));
    });
  }

  @override
  Widget build(BuildContext context) {
    final appbar = AppBar(
      title: const Text('Reorderable list'),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          onPressed: onSort,
          icon: const Icon(Icons.sort_by_alpha),
          tooltip: 'Sort',
        )
      ],
    );
    return Scaffold(
      appBar: appbar,
      body: ReorderableListView(
        onReorder: onReorder,
        children: [
          for (final item in items)
            ListTile(
              key: Key(item),
              title: Text('item $item'),
            )
        ],
      ),
    );
  }
}
