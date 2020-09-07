import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:yellow_naples/utils.dart';

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

  @override
  set value(String newValue) {
    Intl.defaultLocale = newValue;
    super.value = newValue;
  }
}

class TitleModel extends ValueNotifier<FunctionOf<String>> {
  TitleModel(FunctionOf<String> value) : super(value);
}
