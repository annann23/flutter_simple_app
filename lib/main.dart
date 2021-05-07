import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Controller.dart';
import './Calculator.dart';
import './WordList.dart';
import './SavedWords.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Controller(),
        ),
      ],
      child: MaterialApp(
        initialRoute: '/',
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.white,
        ),
        routes: {
          '/': (context) => MainApp(),
          '/calculator': (context) => CalculatorApp(),
          '/wordlist': (context) => WordListApp(),
          '/saved': (context) => SavedWordsApp(),
        },
        title: 'My App',
      ),
    );
  }
}

class MainApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final Controller savedWords =  Provider.of<Controller>(context);
    final AnimationController animationController;
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Flexible(
              child: Center(
                child: ElevatedButton(
                  child: Text(
                    '계산기',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/calculator');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
                  ),
                ),
              ),
            ),
            Flexible(
              child: Center(
                child: ElevatedButton(
                  child: Text(
                    '영단어',
                    style: TextStyle(fontSize: 24),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/wordlist');

                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
                  ),
                ),
              ),
            ),
            Flexible(
              child: Center(
                child: ElevatedButton(
                  child: Text(
                    '즐겨찾기',
                    style: TextStyle(fontSize: 24),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/saved');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}