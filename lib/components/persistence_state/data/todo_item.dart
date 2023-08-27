import 'package:hive/hive.dart';

// part 'todo_item.g.dart';

@HiveType(typeId: 0)
class TodoItem extends HiveObject {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? content;
  @HiveField(2)
  bool isDone;
  @HiveField(3)
  final DateTime createdAt;

  TodoItem({
    this.id,
    this.content,
    this.isDone = false,
    createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  @override
  String toString() {
    return 'TodoItem(id=$id, content=$content, isDone=$isDone, createdAt=$createdAt)';
  }
}
