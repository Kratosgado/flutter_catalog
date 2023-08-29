import 'package:isar/isar.dart';
import 'conversation.dart';

part 'generated/user.g.dart';

@Collection()
class User {
  Id id = Isar.autoIncrement;
  String? username;
  String? email;
  String? phone;
  String? profilePicture;

  final friends = IsarLinks<User>();
  final conversations = IsarLinks<Conversation>();

  bool? isOnline;
}
