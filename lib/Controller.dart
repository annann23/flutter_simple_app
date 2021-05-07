import 'package:flutter/material.dart';

class Controller with ChangeNotifier {
  List savedWords = [];

  addWord(String word){
    savedWords.add(word[0].toUpperCase()+word.substring(1));
    notifyListeners();
  }
  removeWord(word){
    savedWords.remove(word);
    notifyListeners();
  }
  removeWordAt(index){
    savedWords.removeAt(index);
    notifyListeners();
  }
}