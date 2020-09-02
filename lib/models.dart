import 'package:flutter/material.dart';

class SnackModel extends ChangeNotifier {
  String _message;

  String get message => _message;

  set message(String value) {
    _message = value;
    notifyListeners();
  }

  void clear() {
    _message = null;
  }
}

class CurrentLanguageModel extends ValueNotifier<String> {
  CurrentLanguageModel(String value) : super(value);  
}

//Aquests s'haurien de traspassar aquí...
// class TitleModel extends ValueNotifier<String> {
//   TitleModel(String value) : super(value);
// }

// class UidParam extends ValueNotifier<String> {
//   UidParam(String value) : super(value);
// }
