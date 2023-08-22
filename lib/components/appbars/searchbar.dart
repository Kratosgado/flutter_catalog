import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart' as english_words;

class SearchBarExample extends StatefulWidget {
  const SearchBarExample({super.key});

  @override
  State<SearchBarExample> createState() => _SearchBarExampleState();
}

class _SearchBarExampleState extends State<SearchBarExample> {
  final List<String> kEnglishWords;
  late MySearchDelegate delegate;

  _SearchBarExampleState()
      : kEnglishWords = List.from(Set.from(english_words.all))
          ..sort(
            (w1, w2) => w1.toLowerCase().compareTo(w2.toLowerCase()),
          ),
        super();

  @override
  void initState() {
    super.initState();
    delegate = MySearchDelegate(kEnglishWords);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Search Words'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Search',
            icon: const Icon(Icons.search),
            onPressed: () async {
              final String? selected =
                  await showSearch<String>(context: context, delegate: delegate);
              if (mounted && selected != null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('You have selected the word: $selected'),
                ));
              }
            },
          )
        ],
      ),
      body: Scrollbar(
        child: ListView.builder(
          itemCount: kEnglishWords.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(kEnglishWords[index]),
          ),
        ),
      ),
    );
  }
}

class MySearchDelegate extends SearchDelegate<String> {
  final List<String> _words;
  final List<String> _history;

  MySearchDelegate(List<String> words)
      : _words = words,
        _history = <String>['apple', 'hello', 'world', 'flutter'],
        super();

  // leading icon in search bar
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('You have selected the word: '),
            GestureDetector(
              onTap: () => close(context, query),
              child: Text(
                query,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final Iterable<String> suggestions =
        query.isEmpty ? _history : _words.where((word) => word.startsWith(query));

    return SuggestionList(
      query: query,
      suggestions: suggestions.toList(),
      onSelected: (suggestion) {
        query = suggestion;
        _history.insert(0, suggestion);
        showResults(context);
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      if (query.isEmpty)
        IconButton(
          tooltip: 'Voice Search',
          icon: const Icon(Icons.mic),
          onPressed: () => query = 'TODO: implement voice input',
        )
      else
        IconButton(
          tooltip: 'Clear',
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        )
    ];
  }
}

class SuggestionList extends StatelessWidget {
  final List<String> suggestions;
  final String query;
  final ValueChanged<String> onSelected;

  const SuggestionList(
      {super.key, required this.suggestions, required this.query, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.titleMedium!;
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final String suggestion = suggestions[index];
        return ListTile(
          leading: query.isEmpty ? const Icon(Icons.history) : const Icon(null),
          title: RichText(
            text: TextSpan(
                text: suggestion.substring(0, query.length),
                style: textTheme.copyWith(color: Colors.amber),
                children: <TextSpan>[
                  TextSpan(
                    text: suggestion.substring(query.length),
                    style: textTheme,
                  )
                ]),
          ),
          onTap: () => onSelected(suggestion),
        );
      },
    );
  }
}
