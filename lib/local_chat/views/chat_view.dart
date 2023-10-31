import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_catalog/local_chat/isar_service.dart';
import 'package:flutter_catalog/local_chat/models/message.dart';

import 'package:image_picker/image_picker.dart';

import '../models/conversation.dart';
// Import the ChatMessage class

class ChatView extends StatefulWidget {
  static const routename = '/ChatView';

  final Conversation conversation;
  final ChatService chatService;

  const ChatView({required this.chatService, required this.conversation, super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  File? selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(widget.conversation.users.first.profilePicture!),
            ),
            const SizedBox(width: 8.0),
            Text(widget.conversation.users.first.profilePicture!),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.indigo, Colors.amber],
          ),
        ),
        padding: const EdgeInsets.all(1.0),
        child: Column(
          children: [
            buildMessages(),
            buildInput(),
          ],
        ),
      ),
    );
  }

  Future<void> selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
    }
  }

  Widget buildMessages() {
    return Expanded(
      child: StreamBuilder<Conversation?>(
        stream: widget.chatService.listenToChat(widget.conversation),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final messageList = snapshot.data!.messages.toList();

          return ListView.builder(
            // reverse: true,
            itemCount: messageList.length,
            itemBuilder: (context, index) {
              final message = messageList[index];
              final isCurrentUser = index % 2 == 0 ? true : false;
              // final message = Message(text: text, timestamp: DateTime.now(), senderUid: sender);

              return GestureDetector(
                onLongPress: () => widget.chatService.deleteMessage(widget.conversation, message),
                child: chatMessage(
                  message,
                  isCurrentUser,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget buildInput() {
    final TextEditingController textEditingController = TextEditingController();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          if (selectedImage != null) ...[
            Container(
              height: 150, // Set the desired height of the image preview
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: Image.file(selectedImage!),
            ),
            const SizedBox(height: 8.0),
          ],
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: textEditingController,
                  maxLines: null,
                  decoration: InputDecoration(
                    prefixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          color: Colors.blue,
                          icon: const Icon(Icons.image),
                          onPressed: () {
                            selectImage();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.emoji_emotions),
                          color: Colors.blue,
                          onPressed: () {},
                        ),
                      ],
                    ),
                    hintText: 'Type a message...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send_rounded),
                      color: Colors.blue,
                      onPressed: () async {
                        final text = textEditingController.text.trim();

                        if (text.isNotEmpty || selectedImage != null) {
                          // Upload the image to Firebase Storage if selected
                          String? imageUrl;
                          // if (selectedImage != null) {
                          //   imageUrl = await uploadImage(selectedImage!);
                          // }

                          final message = Message(
                            text: text,
                            senderId: widget.conversation.users.first.id,
                            timestamp: DateTime.now(),
                            imageUrl: imageUrl,
                          );

                          await widget.chatService.sendMessage(widget.conversation, message);

                          // Clear the selected image and text input
                          selectedImage = null;
                          textEditingController.clear();
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              // IconButton(
              //   icon: const Icon(Icons.send_rounded),
              //   color: Colors.white,
              //   onPressed: () async {
              //     final text = textEditingController.text.trim();

              //     if (text.isNotEmpty || selectedImage != null) {
              //       // Upload the image to Firebase Storage if selected
              //       String? imageUrl;
              //       // if (selectedImage != null) {
              //       //   imageUrl = await uploadImage(selectedImage!);
              //       // }

              //       final message = Message(
              //         text: text,
              //         senderId: widget.conversation.users.first.id,
              //         timestamp: DateTime.now(),
              //         imageUrl: imageUrl,
              //       );

              //       await widget.chatService.sendMessage(widget.conversation, message);

              //       // Clear the selected image and text input
              //       selectedImage = null;
              //       textEditingController.clear();
              //     }
              //   },
              // ),
            ],
          ),
        ],
      ),
    );
  }
}

Align chatMessage(
  Message message,
  bool isCurrentUser,
) {
  return Align(
    alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: isCurrentUser ? Colors.indigo : Colors.amber,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.imageUrl != null) Image.network(message.imageUrl!),
          if (message.text!.isNotEmpty) ...[
            const SizedBox(height: 4.0),
            Text(
              message.text!,
              style: TextStyle(
                color: isCurrentUser ? Colors.white : Colors.black,
                fontSize: 16.0,
              ),
            ),
          ],
          const SizedBox(height: 4.0),
        ],
      ),
    ),
  );
}
