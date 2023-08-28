import 'package:english_words/english_words.dart' as english_words;
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'package:isar/isar.dart';

import 'data/todo_isar.dart';
import 'isar_service.dart';

class IsarExample extends StatelessWidget {
  IsarExample({super.key});

  late Future<bool> initDbFuture;

  final todos = IsarService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Isar Example')),
      body: StreamBuilder<List<TodoItem>>(
        stream: todos.listenToCourses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No todos found');
          } else {
            final todolist = snapshot.data!;
            return ListView.builder(
              itemCount: todolist.length,
              itemBuilder: (context, index) => itemToListTile(todolist[index]),
            );
          }
        },
      ),
      floatingActionButton: buildFloatingActionButton(),
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
            todos.toggleTodoItem(todo);
          },
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            todos.deleteTodoItem(todo);
          },
        ),
      );

  FloatingActionButton buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () async {
        await todos.addTodoItem(TodoItem(
          content: english_words.generateWordPairs().first.asPascalCase,
          createdAt: DateTime.now(),
          id: Isar.autoIncrement,
        ));
      },
      child: const Icon(Icons.add),
    );
  }
}
