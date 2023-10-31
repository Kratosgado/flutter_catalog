import 'package:flutter/material.dart';

class Entry {
  const Entry(this.title, [this.children = const <Entry>[]]);
  final String title;
  final List<Entry> children;
}

const List<Entry> data = <Entry>[
  Entry(
    'chapter A',
    <Entry>[
      Entry(
        'Section A0',
        <Entry>[
          Entry('Item A0 1'),
          Entry('Item A0 2'),
        ],
      ),
      Entry('Section A1'),
      Entry('Section A2'),
    ],
  ),
  Entry(
    'chapter B',
    <Entry>[
      Entry(
        'Section B0',
        <Entry>[
          Entry('Item B0 1'),
          Entry('Item B0 2'),
        ],
      ),
      Entry('Section B1'),
      Entry('Section B2'),
    ],
  )
];

class EntryItem extends StatelessWidget {
  const EntryItem(this.entry, {super.key});

  final Entry entry;

  Widget buildTiles(Entry root) {
    if (root.children.isEmpty) {
      return ListTile(
        title: Text(root.title),
      );
    }
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: Text(root.title),
      children: root.children.map(buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildTiles(entry);
  }
}

class ExpansionTileExample extends StatelessWidget {
  const ExpansionTileExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => EntryItem(data[index]),
      itemCount: data.length,
    );
  }
}
