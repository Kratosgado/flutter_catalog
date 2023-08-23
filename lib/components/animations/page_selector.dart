import 'package:flutter/material.dart';

class PageSelectorExample extends StatelessWidget {
  const PageSelectorExample({super.key});

  static const kIcons = <Icon>[
    Icon(Icons.event),
    Icon(Icons.home),
    Icon(Icons.android),
    Icon(Icons.alarm),
    Icon(Icons.face),
    Icon(Icons.language),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: kIcons.length,
      child: Builder(
        builder: (context) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const TabPageSelector(),
              Expanded(
                child: IconTheme(
                    data: IconThemeData(
                      size: 128,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    child: const TabBarView(children: kIcons)),
              ),
              ElevatedButton(
                onPressed: () {
                  final TabController controller = DefaultTabController.of(context);
                  if (!controller.indexIsChanging) {
                    controller.animateTo(kIcons.length - 1);
                  }
                },
                child: const Text("SKIP"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
