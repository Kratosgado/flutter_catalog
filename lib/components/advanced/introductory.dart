import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class IntroductionScreenExample extends StatelessWidget {
  const IntroductionScreenExample({super.key});

  static const routename = 'introductory';

  static MaterialPageRoute route() => MaterialPageRoute(
      builder: (_) => const Scaffold(
              body: SafeArea(
            child: IntroductionScreenExample(),
          )));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: IntroductionScreen(
        next: const Icon(Icons.navigate_next),
        showSkipButton: true,
        skip: const Text('Skip'),
        onDone: Navigator.of(context).pop,
        done: const Text('Done'),
        dotsFlex: 3,
        pages: [
          PageViewModel(titleWidget: const Text('title'), body: 'Welcome to the flutter community'),
          PageViewModel(title: 'the second page', body: 'You cal find many examples'),
          PageViewModel(titleWidget: const Text('title'), body: 'Welcome to the flutter community'),
          PageViewModel(title: 'the second page', body: 'You cal find many examples'),
        ],
      ),
    );
  }
}
