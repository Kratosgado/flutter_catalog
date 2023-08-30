import 'package:isar/isar.dart';

import 'conversation.dart';

part 'message.g.dart';

@Collection()
class Message {
  Id id = Isar.autoIncrement;
  final conversation = IsarLink<Conversation>();
  String? text;
  int? senderId;
  String? imageUrl;
  bool? onlyEmoji;

  DateTime timestamp;

  Message({
    this.text,
    this.senderId,
    this.imageUrl,
    this.onlyEmoji,
    required this.timestamp,
  });
}
