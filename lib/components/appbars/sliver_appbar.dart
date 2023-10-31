import 'package:flutter/material.dart';

class SliverAppBarExample extends StatefulWidget {
  const SliverAppBarExample({super.key});

  @override
  State<SliverAppBarExample> createState() => _SliverAppBarExampleState();
}

class _SliverAppBarExampleState extends State<SliverAppBarExample> {
  bool pinned = true, snap = false, floating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: pinned,
            snap: snap,
            floating: floating,
            expandedHeight: 160.0,
            flexibleSpace: const FlexibleSpaceBar(
              title: Text('Flexible title'),
              background: Placeholder(),
            ),
          ),
          const SliverFillRemaining(
            child: Center(
              child: Text("feel me"),
            ),
          ),
        ],
      ),
      bottomNavigationBar: getBottomAppBar(),
    );
  }

  Widget getBottomAppBar() {
    return BottomAppBar(
      child: ButtonBar(
        alignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              const Text('pinned'),
              Switch(value: pinned, onChanged: (val) => setState(() => pinned = val)),
            ],
          ),
          Row(
            children: [
              const Text('snap'),
              Switch(
                  value: snap,
                  onChanged: (val) => setState(() {
                        snap = val;
                        floating = floating || val;
                      })),
            ],
          ),
          Row(
            children: [
              const Text('floating'),
              Switch(
                  value: floating,
                  onChanged: (val) {
                    setState(() {
                      floating = val;
                      if (snap == true) {
                        if (floating != true) {
                          snap = false;
                        }
                      }
                    });
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
