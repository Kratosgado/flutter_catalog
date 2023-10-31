import 'package:like_button/like_button.dart';
import 'package:flutter/material.dart';

class LikeButtonExample extends StatefulWidget {
  const LikeButtonExample({super.key});

  @override
  State<LikeButtonExample> createState() => _LikeButtonExampleState();
}

class _LikeButtonExampleState extends State<LikeButtonExample> {
  final key = GlobalKey<LikeButtonState>();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        const Text('A bare like button: '),
        LikeButton(
          key: key,
        ),
        const Divider(),
        const Text('Like button with count and count: '),
        LikeButton(
          likeBuilder: (isLiked) =>
              isLiked ? const Icon(Icons.thumb_up) : const Icon(Icons.thumb_up_outlined),
          likeCount: 100,
        ),
        const Divider(),
        const Text('Set isLiked = null to make it possible to like multiple times:'),
        LikeButton(
          likeBuilder: (isLiked) => const Icon(Icons.thumb_up),
          likeCount: 996,
          isLiked: null,
          countBuilder: (likeCount, isLiked, text) {
            if (likeCount == 0) return const Text('like');
            return Text(likeCount! >= 1000 ? '${(likeCount / 1000.0).toStringAsFixed(1)}k' : text);
          },
        ),
        const Divider(),
        const ListTile(
          leading: FittedBox(
            child: LikeButton(),
          ),
          title: Text('Like button in list tile'),
          subtitle: Text('Must wrap it by a FittedBox'),
        ),
        const Divider(),
        const ListTile(
          title: Text('use global key to mutate like state elsewhere'),
          subtitle: Text('Click button below to toggle the first like button state'),
        ),
        ElevatedButton(
          onPressed: () => key.currentState?.onTap(),
          child: const Text('toggle'),
        )
      ],
    );
  }
}
