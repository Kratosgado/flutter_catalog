import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:async/async.dart' show AsyncMemoizer;
import 'package:english_words/english_words.dart' as english_words;
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' show join;
import 'package:sqflite/sqflite.dart';

import 'package:flutter/material.dart';

class TodoItem {
  final int? id;
  final String content;
   bool isDone;
  final DateTime createdAt;

  TodoItem({this.id, required this.content, this.isDone = false, required this.createdAt});

  TodoItem.fromJsonMap(Map<String, dynamic> data)
      : id = data['id'] as int,
        content = data['content'] as String,
        isDone = data['isDone'] == 1,
        createdAt = DateTime.fromMillisecondsSinceEpoch(data['createdAt'] as int);

  Map<String, dynamic> toJsonMap() => {
        'id': id,
        'content': content,
        'isDone': isDone ? 1 : 0,
        'createdAt': createdAt.millisecondsSinceEpoch,
      };
}

class SqliteExample extends StatefulWidget {
  const SqliteExample({super.key});

  @override
  State<SqliteExample> createState() => _SqliteExampleState();
}

class _SqliteExampleState extends State<SqliteExample> {
  static const kDbFileName = 'sqflite_ex.db';
  static const kDbTableName = 'example_tb1';
  final memoizer = AsyncMemoizer();

  late Database db;
  List<TodoItem> todos = [];

  Future<void> initDb() async {
    final dbFolder = await getDatabasesPath();
    if (!await Directory(dbFolder).exists()) {
      await Directory(dbFolder).create(recursive: true);
    }
    final dbPath = join(dbFolder, kDbFileName);
    db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async => await db.execute("""
        CREATE TABLE $kDbTableName(
          id INTEGER PRIMARY KEY,
          isDone BIT NOT NULL,
          content TEXT,
          createdAt INT
        )
        """),
    );
  }

  // retrieves rows from the db table
  Future<void> getTodoItems() async {
    final List<Map<String, dynamic>> jsons = await db.query(kDbTableName);
    debugPrint('${jsons.length} rows retrieved from db ******');
    todos = jsons.map((e) => TodoItem.fromJsonMap(e)).toList();
  }

  // Insert records to the db table
  Future<void> addTodoItem(TodoItem todo) async {
    await db.transaction((txn) async {
      final int id = await txn.insert(kDbTableName, todo.toJsonMap());
      debugPrint('Inserted todo item with id = $id');
    });
  }

  // updates records in the db table
  Future<void> toggleTodoItem(TodoItem todo) async {
    final int count = await db.rawUpdate(/*sql*/ '''
      UPDATE $kDbTableName
      SET isDone = ?
      WHERE id = ?
      ''', /*args*/ [if (todo.isDone) 0 else 1, todo.id]);
    debugPrint('Updated $count records in db.');
  }

  Future<void> switchTodo(TodoItem todo) async {
    final int count = await db.update(kDbTableName, todo.toJsonMap(),
        where: 'id = ${todo.id}', whereArgs: [if (todo.isDone) 0 else 1]);
    debugPrint('Updated $count records in db.');
  }

  // Deletes records inthe db table
  Future<void> deleteTodoItem(TodoItem todo) async {
    final count = await db.delete(kDbTableName, where: 'id = ${todo.id}');
    debugPrint('Updated $count records in db');
  }

  Future<bool> asyncInit() async {
    // avoid this function to be called multiple times,

    await memoizer.runOnce(() async {
      await initDb();
      await getTodoItems();
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: asyncInit(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == false) {
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
