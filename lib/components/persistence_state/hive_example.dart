import 'package:english_words/english_words.dart' as english_words;
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'data/todo_item.dart' show TodoItem, TodoItemAdapter;

class HiveExample extends StatefulWidget {
  const HiveExample({super.key});

  @override
  State<HiveExample> createState() => _HiveExampleState();
}

class _HiveExampleState extends State<HiveExample> {
  static const kHiveFolder = 'hive';
  static const kHiveBoxName = 'todosBox';

  late Future<bool> initDbFuture;

  @override
  void initState() {
    super.initState();
    initDbFuture = initDb();
  }

  // initializes the hive DB, once done the hive operations are synchronous
  Future<bool> initDb() async {
    // initialize hive
    final dir = await path_provider.getApplicationDocumentsDirectory();
    final hiveFolder = join(dir.path, kHiveFolder);
    Hive.init(hiveFolder);
    try {
      Hive.registerAdapter(TodoItemAdapter());
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
    // open the hive box so that we can later call Hive.box(<name>) to use it
    await Hive.openBox<TodoItem>(kHiveBoxName);
    debugPrint('Hive initialization done, todo items int he db are:');
    return true;
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  // returns all the todo items in the db
  List<TodoItem> getTodoItems() {
    final box = Hive.box<TodoItem>(kHiveBoxName);
    return box.values.toList();
  }

  // adds a new todo item to the db
  Future<void> addTodoItem(TodoItem todo) async {
    final box = Hive.box<TodoItem>(kHiveBoxName);
    final int key = await box.add(todo);
    todo.id = key;
    await todo.save();
    debugPrint('Added todo item: $todo');
  }

  // updates records in the db table
  Future<void> toggleTodoItem(TodoItem todo) async {
    todo.isDone = !todo.isDone;
    await todo.save();
    debugPrint('Updated todo item: $todo');
  }

  // deletes records from the db table
  Future<void> deleteTodoItem(TodoItem todo) async {
    await todo.delete();
    debugPrint('Deleted todo item: $todo');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: initDbFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: const Text('Hive Example')),
            body: ValueListenableBuilder<Box<TodoItem>>(
              valueListenable: Hive.box<TodoItem>(kHiveBoxName).listenable(),
              builder: (context, box, _) {
                final todos = box.values.toList();
                return ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) => itemToListTile(todos[index]),
                );
              },
            ),
            floatingActionButton: buildFloatingActionButton(),
          );
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  ListTile itemToListTile(TodoItem todo) => ListTile(
        title: Text(
          todo.content!,
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
          onPressed: () {
            toggleTodoItem(todo);
          },
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            deleteTodoItem(todo);
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
      },
      child: const Icon(Icons.add),
    );
  }
}
