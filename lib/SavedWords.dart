import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Controller.dart';

class SavedWordsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SavedWords(),
    );
  }
}

class SavedWords extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Controller c =  Provider.of<Controller>(context);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Saved words"),
        centerTitle: true,
      ),
      body: Center(
        child: ListView.separated(
            itemCount: c.savedWords.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  '${c.savedWords[index]}',
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.red,
                    size: 28,
                  ),
                  onPressed: () {
                    c.removeWordAt(index);
                  },
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
          ),
      ),
    );
  }
}
