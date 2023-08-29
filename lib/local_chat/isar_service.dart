import 'package:flutter_catalog/local_chat/models/conversation.dart';
import 'package:flutter_catalog/local_chat/models/message.dart';
import 'package:flutter_catalog/local_chat/models/user.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class ChatService {
  late Future<Isar> db;
  ChatService() {
    db = initDb();
  }

  Future<Isar> initDb() async {
    final appDocsDir = await path_provider.getApplicationDocumentsDirectory();
    return await Isar.open([MessageSchema, ConversationSchema, UserSchema],
        directory: appDocsDir.path, inspector: true);
  }
}
