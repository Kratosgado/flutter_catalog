import 'package:flutter/material.dart';
import 'package:flutter_catalog/local_chat/models/conversation.dart';
import 'package:flutter_catalog/local_chat/views/users_view.dart';

import '../isar_service.dart';

class ConversationsView extends StatelessWidget {
  static const routename = 'conversationView';
  const ConversationsView({super.key, required this.chatService});

  final ChatService chatService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Isar Local Chat')),
      body: StreamBuilder<List<Conversation>>(
        stream: chatService.listenToConversations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No chatService found');
          } else {
            final conversationList = snapshot.data!;
            return ListView.builder(
              itemCount: conversationList.length,
              itemBuilder: (context, index) => converationTile(conversationList[index]),
            );
          }
        },
      ),
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  ListTile converationTile(Conversation conversation) {
    if (conversation.users.isEmpty) {
      return const ListTile(
        title: Text('no user in conversation'),
      );
    }
    return ListTile(
      title: Text(
        conversation.users.first.username!,
        style: const TextStyle(
          fontStyle: FontStyle.italic,
          color: Colors.grey,
          decoration: TextDecoration.lineThrough,
        ),
      ),
      subtitle: Text(conversation.messages.first.text!),
      isThreeLine: true,
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          chatService.deleteConversation(conversation);
        },
      ),
    );
  }

  FloatingActionButton buildFloatingActionButton(context) {
    return FloatingActionButton(
      onPressed: () => Navigator.of(context).restorablePushNamed(UserSelectPage.routename),
      child: const Icon(Icons.message),
    );
  }
}
