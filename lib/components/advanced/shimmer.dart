import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerExample extends StatelessWidget {
  const ShimmerExample({super.key});

  static const routeName = "shimmerExample";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("shimmer effect")),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          const Shimmer(
              gradient: LinearGradient(colors: [Colors.blue, Colors.black, Colors.teal]),
              child: Text("data")),
          Shimmer.fromColors(
            baseColor: Colors.grey[400]!,
            highlightColor: Colors.grey[100]!,
            child: const ListTile(
              title: Text('Slide to unlock'),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
          ),
          const Divider(),
          Shimmer(
            gradient: LinearGradient(colors: [Colors.blue, Colors.amber, Colors.teal]),

            // baseColor: Colors.grey[400]!,
            // highlightColor: Colors.grey[100]!,
            // direction: ShimmerDirection.rtl,
            enabled: true,
            child: Column(
              children: [1, 2, 3, 4, 4].map((e) => placeHolderRow()).toList(),
            ),
          )
        ],
      ),
    );
  }
}

Widget placeHolderRow() => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          color: Colors.white,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
        ),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 8,
              color: Colors.white,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 2),
            ),
            Container(
              width: 40,
              height: 8,
              color: Colors.white,
            )
          ],
        ))
      ],
    );
