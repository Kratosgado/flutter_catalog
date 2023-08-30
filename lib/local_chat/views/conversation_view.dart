import 'package:flutter/material.dart';
import 'package:flutter_catalog/local_chat/models/conversation.dart';
import 'package:flutter_catalog/local_chat/views/chat_view.dart';
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
              itemBuilder: (context, index) => converationTile(context, conversationList[index]),
            );
          }
        },
      ),
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  ListTile converationTile(context, Conversation conversation) {
    if (conversation.users.isEmpty) {
      return const ListTile(
        title: Text('no user in conversation'),
      );
    }
    return ListTile(
      leading: Hero(
        tag: 'profile_pic_tag_${conversation.id}',
        child: CircleAvatar(
          backgroundImage: AssetImage(conversation.users.first.profilePicture!),
        ),
      ),
      title: Text(
        conversation.users.first.username!,
      ),
      subtitle: conversation.messages.isEmpty
          ? const Text('No messages')
          : Text(conversation.messages.first.text!),
      isThreeLine: true,
      onTap: () => Navigator.of(context).pushNamed(ChatView.routename, arguments: conversation),
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
