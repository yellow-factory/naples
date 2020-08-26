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
