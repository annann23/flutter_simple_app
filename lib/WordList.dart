import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:provider/provider.dart';
import 'Controller.dart';

class WordListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RandomWords(),
    );
  }
}

class RandomWords extends StatelessWidget {
  final _suggestions = <String>[];


  @override
  Widget build(BuildContext context) {
    final Controller c =  Provider.of<Controller>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("English words"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.star),
            color: Colors.orange,
            iconSize: 28,
            onPressed: () {
              Navigator.pushNamed(context, '/saved');
            },
          )
        ],
      ),
      body: Center(
        child: ListView.builder(
          itemBuilder: (context, i) {
            if (i.isOdd) return Divider();

            final index = i ~/ 2;
            if (index >= _suggestions.length) {
              _suggestions.addAll(nouns.getRange(index, index + 10));
            }
            return _buildRow(_suggestions[index], c);
          },
        ),
      ),
    );
  }

  Widget _buildRow(String word, Controller c) {
    final wordToUpperCase = word[0].toUpperCase()+word.substring(1);

    return ListTile(
      title: Text(
        '$wordToUpperCase',
        style: TextStyle(color: Colors.black, fontSize: 18),
      ),
      trailing: Icon(
          c.savedWords.contains(wordToUpperCase) ? Icons.star : Icons.star_border,
          color: c.savedWords.contains(wordToUpperCase) ? Colors.orange : null,
          size: 28,
      ),
      onTap: () {
        if (c.savedWords.contains(wordToUpperCase)) {
          c.removeWord(wordToUpperCase);
        } else {
          c.addWord(wordToUpperCase);
        }
      },
    );
  }
}
