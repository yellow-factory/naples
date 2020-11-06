import 'package:navy/navy.dart';

abstract class ModelProperty<U> {
  String get label;
  String get hint;
  bool get autofocus;
  PredicateOf0 get editable;
  FunctionOf0<U> get getProperty;
  ActionOf1<U> get setProperty;
  FunctionOf1<U, String> get validator;

  bool get initialValid => validator == null ? true : validator(getProperty()) == null;
}
