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

  Future<void> addConversation(Conversation conversation) async {
    final chat = await db;
    chat.writeTxnSync(() => chat.conversations.putSync(conversation));
  }

  Future<void> deleteConversation(Conversation conversation) async {
    final chat = await db;
    chat.writeTxnSync(() => chat.conversations.deleteSync(conversation.id));
  }

  Future<void> cleanDb() async {
    final chat = await db;
    chat.writeTxnSync(() => chat.clear());
  }

  Stream<List<Conversation>> listenToConversations() async* {
    final chat = await db;
    yield* chat.conversations.where().watch(fireImmediately: true);
  }

  Stream<List<User>> listenToUsers() async* {
    final chat = await db;
    yield* chat.users.where().watch(fireImmediately: true);
  }

  Future<void> addUser(User user) async {
    final chat = await db;
    chat.writeTxnSync(() => chat.users.putSync(user));
  }

  Future<Isar> initDb() async {
    final appDocsDir = await path_provider.getApplicationDocumentsDirectory();
    return await Isar.open([MessageSchema, ConversationSchema, UserSchema],
        directory: appDocsDir.path, inspector: true);
  }
}
