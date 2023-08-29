import 'package:flutter/material.dart';
import 'package:flutter_catalog/local_chat/isar_service.dart';
import 'package:flutter_catalog/local_chat/views/add_user_view.dart';

import '../models/user.dart';

class UserSelectPage extends StatelessWidget {
  final ChatService chatService;
  const UserSelectPage({super.key, required this.chatService});

  static const routename = '/UserSelectPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversations'),
        backgroundColor: Colors.indigo, // Change the app bar color
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.amber, Colors.indigo],
          ),
        ),
        padding: const EdgeInsets.all(10.0),
        child: Card(
          color: Colors.white,
          child: StreamBuilder<List<User>>(
            stream: chatService.listenToUsers(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 18, 62, 123)),
                  ),
                );
              }

              final userList = snapshot.data!;

              return ListView.builder(
                itemCount: userList.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white,
                    elevation: 10,
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(userList[index].profilePicture!),
                      ),
                      title: Text(
                        userList[index].username!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      onTap: () {},
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.of(context).restorablePushNamed(AddUserView.routename),
      ),
    );
  }
}
