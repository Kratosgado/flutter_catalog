import 'package:english_words/english_words.dart' as english_words;
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import 'sqflite_sql.dart' show TodoItem;

class SembastExample extends StatefulWidget {
  const SembastExample({super.key});

  @override
  State<SembastExample> createState() => _SembastExampleState();
}

class _SembastExampleState extends State<SembastExample> {
  static const kDbFileName = 'sembast_ex.db';
  static const kDbStoreName = 'example_store';

  late Future<bool> initDbFuture;
  late Database db;
  late StoreRef<int, Map<String, dynamic>> store;
  List<TodoItem> todos = [];

  @override
  void initState() {
    super.initState();
    initDbFuture = initDb();
  }

  // opens a db local file. Creates the db table if it's not yet created
  Future<bool> initDb() async {
    final dbFolder = await path_provider.getApplicationDocumentsDirectory();
    final dbPath = join(dbFolder.path, kDbFileName);
    db = await databaseFactoryIo.openDatabase(dbPath);
    debugPrint('Db created at $dbPath');
    store = intMapStoreFactory.store(kDbStoreName);
    getTodoItems();
    return true;
  }

  // retrieves records fromt he db store
  Future<void> getTodoItems() async {
    final finder = Finder();
    final recordSnapshots = await store.find(db, finder: finder);
    todos = recordSnapshots
        .map(
          (snapshot) => TodoItem.fromJsonMap({
            ...snapshot.value,
            'id': snapshot.key,
          }),
        )
        .toList();
  }

  // Inserts records to the db store
  Future<void> addTodoItem(TodoItem todo) async {
    final int id = await store.add(db, todo.toJsonMap());
    debugPrint("Inserted todo item with id: $id");
  }

  // updates records in the db table
  Future<void> toggleTodoItem(TodoItem todo) async {
    todo.isDone = !todo.isDone;
    final int count = await store.update(
      db,
      todo.toJsonMap(),
      finder: Finder(filter: Filter.byKey(todo.id)),
    );
    debugPrint('Updated $count in db');
  }

  // deletes records int the db table
  Future<void> deleteTodoItem(TodoItem todo) async {
    final int count = await store.delete(db, finder: Finder(filter: Filter.byKey(todo.id)));
    debugPrint('updated $count records in db.');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: initDbFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          body: ListView(
            children: todos.map((e) => itemToListTile(e)).toList(),
          ),
          floatingActionButton: buildFloatingActionButton(),
        );
      },
    );
  }

  Future<void> updateUI() async {
    await getTodoItems();
    setState(() {});
  }

  ListTile itemToListTile(TodoItem todo) => ListTile(
        title: Text(
          todo.content,
          style: TextStyle(
            fontStyle: todo.isDone ? FontStyle.italic : null,
            color: todo.isDone ? Colors.grey : null,
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text('id=${todo.id}\ncreated at ${todo.createdAt}'),
        isThreeLine: true,
        leading: IconButton(
          icon: Icon(todo.isDone ? Icons.check_box : Icons.check_box_outline_blank),
          onPressed: () async {
            await toggleTodoItem(todo);
            updateUI();
          },
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () async {
            await deleteTodoItem(todo);
            updateUI();
          },
        ),
      );

  FloatingActionButton buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () async {
        await addTodoItem(TodoItem(
          content: english_words.generateWordPairs().first.asPascalCase,
          createdAt: DateTime.now(),
        ));
        updateUI();
      },
      child: const Icon(Icons.add),
    );
  }
}
