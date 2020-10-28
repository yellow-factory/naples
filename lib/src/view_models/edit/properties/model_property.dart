import 'package:flutter/widgets.dart';
import 'package:naples/widgets/expandable.dart';
import 'package:navy/navy.dart';

abstract class ModelProperty<U> extends Expandable {
  //Es podria fer servir el onSave per realitzar el setProperty, però no estic segur si és la millor opció
  //https://forum.freecodecamp.org/t/how-to-validate-forms-and-user-input-the-easy-way-using-flutter/190377

  final int flex;
  final String label;
  final String hint;
  final FunctionOf0<U> getProperty;
  final bool autofocus;
  final ActionOf1<U> setProperty;
  final PredicateOf0 isEditable;
  final FunctionOf1<U, String> isValid;

  ModelProperty(
      {Key key,
      @required this.getProperty,
      this.label,
      this.hint,
      this.flex,
      this.autofocus = false,
      this.setProperty,
      this.isEditable,
      this.isValid})
      : super(key: key);
}
