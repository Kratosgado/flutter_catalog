import 'package:english_words/english_words.dart' as english_words;
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'data/todo_item.dart' show TodoItem;

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
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
