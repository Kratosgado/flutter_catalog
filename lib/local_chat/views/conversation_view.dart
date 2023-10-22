import 'package:animations/animations.dart';
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

  OpenContainer converationTile(context, Conversation conversation) {
    return OpenContainer(
      transitionDuration: const Duration(milliseconds: 500),
      closedBuilder: (ctx, action) => ListTile(
        leading: GestureDetector(
          onTap: () => viewProfileImage(context, conversation),
          child: Hero(
            tag: 'profile_pic_tag_${conversation.id}',
            child: CircleAvatar(
              backgroundImage: AssetImage(conversation.users.first.profilePicture!),
            ),
          ),
        ),
        title: Text(
          conversation.users.first.username!,
        ),
        subtitle: conversation.messages.isEmpty
            ? const Text('No messages')
            : Text(conversation.messages.first.text!),
        isThreeLine: true,
        // onTap: () => Navigator.of(context).pushNamed(ChatView.routename, arguments: conversation),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            chatService.deleteConversation(conversation);
          },
        ),
      ),
      openBuilder: (context, action) =>
          ChatView(chatService: chatService, conversation: conversation),
    );
  }

  FloatingActionButton buildFloatingActionButton(context) {
    return FloatingActionButton(
      onPressed: () => Navigator.of(context).restorablePushNamed(UserSelectPage.routename),
      child: const Icon(Icons.message),
    );
  }
}

void viewProfileImage(context, Conversation conversation) {
  Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: Text(conversation.users.first.username!),
            ),
            body: Center(
              child: Hero(
                tag: 'profile-pic-tag_${conversation.id}',
                child: Image.asset(conversation.users.first.profilePicture!),
              ),
            ),
          )));
}
