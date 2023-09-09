import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:english_words/english_words.dart' as english_words;
import 'package:flutter_catalog/local_chat/views/conversation_view.dart';

class FeatureDiscoveryExample extends StatelessWidget {
  const FeatureDiscoveryExample({super.key});

  static const routename = '/featureDiscory';

  @override
  Widget build(BuildContext context) {
    return FeatureDiscovery(child: const DemoPage());
  }
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  static const kFeatureId1Add = 'feature1_add';
  static const kFeatureId2Sub = 'feature2_substract';
  static const kFeatureId3Refresh = 'feature3_refresh';

  late List<String> strsToShow;
  late GlobalKey<EnsureVisibleState> ensureVisibleGlobalKey;

  List<String> getRandomStrings() {
    return <String>[
      for (final wordPair in english_words.generateWordPairs().take(20)) wordPair.asPascalCase
    ];
  }

  @override
  void initState() {
    super.initState();
    ensureVisibleGlobalKey = GlobalKey<EnsureVisibleState>();
    strsToShow = getRandomStrings();

    // show feature discovery right after the page is ready
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) => showDiscovery());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: buildFabColumn(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            const Text(
              'This is a simple page showing a list of random words, and has 3 buttons: add one/ remove one / regresh. \n\n Feature discovery will go through and introduce them',
            ),
            ElevatedButton.icon(
                onPressed: showDiscovery,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start feature discovery')),
            const Divider(),
            for (final str in strsToShow)
              Card(
                child: ListTile(title: Text(str)),
              ),
            buildRefreshBtn(context)
          ],
        ),
      ),
    );
  }

  DescribedFeatureOverlay buildRefreshBtn(context) {
    return DescribedFeatureOverlay(
      featureId: kFeatureId3Refresh,
      tapTarget: const Icon(Icons.refresh),
      title: const Text('Refresh'),
      description: const Text('Tap the refresh button to re-generate the random text list'),
      backgroundColor: Theme.of(context).primaryColor,
      onOpen: () async {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          ensureVisibleGlobalKey.currentState?.ensureVisible(
            preciseAlignment: 0.5,
            duration: const Duration(milliseconds: 400),
          );
        });
        return true;
      },
      onComplete: () async {
        Navigator.of(context).popAndPushNamed(ConversationsView.routename);
        return true;
      },
      // use ensure visible to scrll to the button during feature discovery.
      // **NOTE** to make this work, the scrollable widget must be a
      // SingleChildScrollView, ListView will NOT work
      child: EnsureVisible(
        key: ensureVisibleGlobalKey,
        child: ElevatedButton.icon(
          icon: const Icon(Icons.refresh),
          onPressed: () => setState(() => strsToShow = getRandomStrings()),
          label: const Text('Refresh words'),
        ),
      ),
    );
  }

  Column buildFabColumn(context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // use DescribedFeatureOverlay to describe each widget
        DescribedFeatureOverlay(
            featureId: kFeatureId1Add,
            // the widget that will be displayed as the tap target
            tapTarget: const Icon(Icons.plus_one),
            contentLocation: ContentLocation.above,
            title: const Text('Plus One'),
            description: const Text('Tap the plus icon to add an item to your list'),
            backgroundColor: Theme.of(context).primaryColor,
            child: FloatingActionButton(
              onPressed: () => setState(
                  () => strsToShow.insert(0, english_words.generateWordPairs().first.asCamelCase)),
              heroTag: 'plus_one',
              child: const Icon(Icons.plus_one),
            )),
        const SizedBox(
          height: 4,
        ),
        DescribedFeatureOverlay(
          featureId: kFeatureId2Sub,
          tapTarget: const Icon(Icons.exposure_minus_1),
          title: const Text('Minus one'),
          description: const Text('Tap the minus icon to remove an item from list'),
          backgroundColor: Theme.of(context).primaryColor,
          child: FloatingActionButton(
            heroTag: 'minus_one',
            onPressed: () => setState(() {
              strsToShow.removeAt(0);
            }),
            child: const Icon(Icons.exposure_minus_1),
          ),
        )
      ],
    );
  }

  Future<void> showDiscovery() async {
    // clear the 'feature discovered' data, otherwise it'll show up only for the first time,
    await FeatureDiscovery.clearPreferences(
      context,
      <String>{kFeatureId1Add, kFeatureId2Sub, kFeatureId3Refresh},
    );
    if (!mounted) return;

    // start feature dicovery
    FeatureDiscovery.discoverFeatures(
        context, const <String>{kFeatureId1Add, kFeatureId2Sub, kFeatureId3Refresh});

    // final isShown = FeatureDiscovery.hasPreviouslyCompleted(context, kFeatureId1Add);
    // ScaffoldMessenger.of(context)
    //     .showSnackBar(SnackBar(content: Text('FeatureDiscovery shown = $isShown')));
  }
}
