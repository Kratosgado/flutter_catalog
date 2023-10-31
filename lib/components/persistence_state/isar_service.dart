import 'package:isar/isar.dart';

import 'package:path_provider/path_provider.dart' as path_provider;
import 'data/todo_isar.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = initDb();
  }

  // retrieve all items
  Future<List<TodoItem>> getTodoItems() async {
    final isar = await db;
    return await isar.todoItems.where().findAll();
  }

  // listen for changes in todo item collection
  Stream<List<TodoItem>> listenToCourses() async* {
    final isar = await db;
    yield* isar.todoItems.where().watch(fireImmediately: true);
  }

  // deletes all tuples in database
  Future<void> cleanDb() async {
    final isar = await db;
    await isar.writeTxn(() => isar.clear());
  }

  // deletes a tuple from database
  Future<void> deleteTodoItem(TodoItem todo) async {
    final isar = await db;
    isar.writeTxnSync(() => isar.todoItems.deleteSync(todo.id));
  }

  // toggle isDone
  Future<void> toggleTodoItem(TodoItem todo) async {
    final isar = await db;
    todo.isDone = !todo.isDone;
    isar.writeTxnSync(() => isar.todoItems.putSync(todo));
  }

  // insert todo item
  Future<void> addTodoItem(TodoItem todo) async {
    final isar = await db;
    isar.writeTxnSync(() => isar.todoItems.putSync(todo));
  }

  Future<Isar> initDb() async {
    if (Isar.instanceNames.isEmpty) {
      final appDocsDir = await path_provider.getApplicationDocumentsDirectory();
      return await Isar.open([TodoItemSchema], directory: appDocsDir.path, inspector: true);
    }
    return Future.value(Isar.getInstance());
  }
}
