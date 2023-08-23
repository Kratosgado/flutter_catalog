import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

class HeroExample extends StatelessWidget {
  const HeroExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          OpenContainer(
            transitionDuration: const Duration(milliseconds: 500),
            closedBuilder: (ctx, action) => ListTile(
              leading: GestureDetector(
                onTap: () => viewProfileImage(context),
                child: const Hero(
                  tag: 'profile-image-tag',
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/kratos.jpg'),
                  ),
                ),
              ),
              title: const Text('Kratos Gado'),
            ),
            openBuilder: (ctx, action) => const Scaffold(
              body: Center(
                child: Text('New Page'),
              ),
            ),
          )
        ],
      ),
    );
  }
}

void viewProfileImage(context) {
  Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: const Text('Kratos Gado'),
            ),
            body: Center(
              child: Hero(
                tag: 'progile-image-tag',
                child: Image.asset('assets/images/kratos.jpg'),
              ),
            ),
          )));
}
