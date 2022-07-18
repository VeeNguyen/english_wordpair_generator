import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _randomWordPair = <WordPair>[];
  final _savedWordPair = <WordPair>{};

  Widget _buildList() {
    return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, item) {
          // adding the divider in between the word pairs
          if (item.isOdd) return const Divider();

          // number of word pairs in the list minus the divider
          final index = item ~/ 2;

          // generate new word pairs as scrolling down
          if (index >= _randomWordPair.length) {
            _randomWordPair.addAll(generateWordPairs().take(10));
          }

          // final return the build rows of word pairs
          return _buildRow(_randomWordPair[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    // see if the pair is already in saved
    final alreadySaved = _savedWordPair.contains(pair);

    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: const TextStyle(fontSize: 18),
      ),
      trailing: Icon(
        // if it is alreadySaved, then Icon is favorite, else favorite_border
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        // if it is alreadySaved, then Color is red, else null
        color: alreadySaved ? Colors.red : null,
      ),

      // add event when click the heart icon
      onTap: () {
        setState(
          () {
            if (alreadySaved) {
              _savedWordPair.remove(pair);
            } else {
              _savedWordPair.add(pair);
            }
          },
        );
      },
    );
  }

  // Using Navigator to route to a different page
  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          // a list of saved word pairs
          final Iterable<ListTile> mytiles = _savedWordPair.map(
            (WordPair pair) {
              return ListTile(
                title: Text(pair.asPascalCase),
                // style: TextStyle(fontSize: 16.0),
              );
            },
          );

          final List<Widget> divided =
              ListTile.divideTiles(context: context, tiles: mytiles).toList();

          return Scaffold(
            appBar: AppBar(
              title: const Text("Favorite WordPairs"),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WordPair Gen"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
          )
        ],
      ),
      body: _buildList(),
    );
  }
}
