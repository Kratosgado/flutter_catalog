import 'package:isar/isar.dart';
import 'message.dart';
import 'user.dart';

part 'generated/conversation.g.dart';

@Collection()
class Conversation {
  Id id = Isar.autoIncrement;

  @Backlink(to: 'conversations')
  final users = IsarLinks<User>();

  final messages = IsarLinks<Message>();
}
