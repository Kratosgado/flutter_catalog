import 'package:device_preview/device_preview.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_catalog/blog_sample/homepage.dart';
import 'package:flutter_catalog/components/advanced/feature_discovery.dart';
import 'package:flutter_catalog/components/persistence_state/isar_example.dart';
import 'package:flutter_catalog/local_chat/isar_service.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:isar/isar.dart';
import 'package:firebase_database/firebase_database.dart';

import 'components/advanced/introductory.dart';
import 'local_chat/models/conversation.dart';
import 'local_chat/views/add_user_view.dart';
import 'local_chat/views/chat_view.dart';
import 'local_chat/views/conversation_view.dart';
import 'local_chat/views/users_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Isar.initializeIsarCore();
  final chatService = ChatService();
  runApp(MyApp(
    chatService: chatService,
  ));
}

class DevicePreviewExample extends StatefulWidget {
  const DevicePreviewExample({required this.chatService, super.key});

  final ChatService chatService;

  @override
  State<DevicePreviewExample> createState() => _DevicePreviewExampleState();
}

class _DevicePreviewExampleState extends State<DevicePreviewExample> {
  @override
  Widget build(BuildContext context) {
    return DevicePreview(
      enabled: true,
      builder: (_) => MyApp(
        chatService: widget.chatService,
      ),
      tools: const [
        ...DevicePreview.defaultTools,
      ],
    );
  }
}

class MyApp extends StatelessWidget {
  final ChatService chatService;
  const MyApp({super.key, required this.chatService});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Catalog',
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData(
        useMaterial3: false,
      ),
      // home: const IntroductionScreenExample(),
      initialRoute: IntroductionScreenExample.routename,
      // ),
      onGenerateRoute: (RouteSettings routeSettings) {
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (BuildContext context) {
            switch (routeSettings.name) {
              case UserSelectPage.routename:
                return UserSelectPage(chatService: chatService);
              case AddUserView.routename:
                return AddUserView(chatService: chatService);
              case ChatView.routename:
                final Conversation args = routeSettings.arguments as Conversation;
                return ChatView(chatService: chatService, conversation: args);
              case FeatureDiscoveryExample.routename:
                return const FeatureDiscoveryExample();
              case ConversationsView.routename:
                return ConversationsView(chatService: chatService);
              default:
                return const IntroductionScreenExample();
            }
          },
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Container(
            height: 100,
            color: Colors.deepPurple,
            alignment: Alignment.center,
            child: const Text(
              "Mbeah Catalog",
              style: TextStyle(
                color: Colors.white,
                fontSize: 50,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          )),
      body: IsarExample(),
    );
  }
}
