import 'package:flutter/widgets.dart';
import 'package:navy/navy.dart';

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

class TitleModel extends ValueNotifier<FunctionOf<String>> {
  TitleModel(FunctionOf<String> value) : super(value);
}
