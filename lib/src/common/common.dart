import 'package:flutter/widgets.dart';
import 'package:navy/navy.dart';

///Interface to implement in a Widget that can be expanded,
///has the information to be expanded
abstract class Expandable {
  int get flex;
}

abstract class IMustacheValues {
  Map<String, dynamic> mustacheValues(String locale);
}

//TODO: Remove
abstract class Validable {
  bool get initialValid;
  ActionOf1<bool>? get onValidChanged;
}

abstract class HasBuilder {
  FunctionOf2<Widget, bool, Widget> get builder;
}
