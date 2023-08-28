import 'package:isar/isar.dart';

@collection
class TodoItem {
  Id id = Isar.autoIncrement;
  String? content;
  bool? isDone;
  DateTime? createdAt;

  TodoItem({
    required this.id,
    required this.content,
    this.isDone = false,
    this.createdAt,
  });
}
