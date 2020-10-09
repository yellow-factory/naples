import 'package:naples/src/view_models/edit/properties/view_property.dart';
import 'package:navy/navy.dart';

abstract class ModelProperty<U> extends ViewProperty {
  //Es podria fer servir el onSave per realitzar el setProperty, però no estic segur si és la millor opció
  //https://forum.freecodecamp.org/t/how-to-validate-forms-and-user-input-the-easy-way-using-flutter/190377

  final FunctionOf0<String> label;
  final FunctionOf0<String> hint;
  final FunctionOf0<U> getProperty;
  final bool autofocus;
  final ActionOf1<U> setProperty;
  final PredicateOf0 isEditable;
  final FunctionOf1<U, String> isValid;

  ModelProperty(this.getProperty,
      {this.label,
      this.hint,
      int flex,
      this.autofocus = false,
      this.setProperty,
      PredicateOf0 isVisible,
      this.isEditable,
      this.isValid})
      : super(flex: flex, isVisible: isVisible) {
    initialize();
  }

  void initialize();

  bool get editable => isEditable != null ? isEditable() : this.setProperty != null;

  String validate() => isValid != null ? isValid(currentValue) : null;

  U currentValue;

  bool get valid => validate() == null;
  void update() {
    if (!valid) throw Exception("Cannot update an invalid property");
    if (this.setProperty == null) throw Exception("setProperty not set");
    this.setProperty(currentValue);
    //notifies the changes to the property because they may use the source
    notifyListeners();
  }

  void undo() {
    initialize();
  }
}
