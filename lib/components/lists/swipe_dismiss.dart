import 'package:flutter/material.dart';

class ListSwipeToDismissExample extends StatefulWidget {
  const ListSwipeToDismissExample({super.key});

  @override
  State<ListSwipeToDismissExample> createState() => _ListSwipeToDismissExampleState();
}

class _ListSwipeToDismissExampleState extends State<ListSwipeToDismissExample> {
  final items = List<String>.generate(20, (index) => 'Item ${index + 1}');

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final String item = items[index];

        return Dismissible(
          key: Key(item),
          onDismissed: (direction) {
            setState(() {
              items.removeAt(index);
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                direction == DismissDirection.startToEnd ? '$item removed.' : '$item liked.',
              ),
              action: SnackBarAction(
                label: 'UNDO',
                onPressed: () => setState(() {
                  items.insert(index, item);
                }),
              ),
            ));
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            child: const Icon(Icons.delete),
          ),
          secondaryBackground: Container(
            color: Colors.green,
            alignment: Alignment.centerRight,
            child: const Icon(Icons.thumb_up),
          ),
          child: ListTile(
              title: Center(
            child: Text(items[index]),
          )),
        );
      },
    );
  }
}
