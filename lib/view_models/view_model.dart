import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:navy/navy.dart';

abstract class Refreshable implements Initialized {
  Future<void> refresh();
}

abstract class ViewModel extends ChangeNotifier with OneTimeInitializable1<BuildContext> {
  BuildContext context;

  @override
  Future<void> init1(BuildContext context) async {
    this.context = context;
  }

  T getProvided<T>() => Provider.of<T>(context, listen: false);

  String get title;
  Widget get widget;
}

abstract class ViewModelOf<T> extends ViewModel {
  T model;
  ViewModelOf();
}

abstract class ViewProperty extends ChangeNotifier {
  final int flex;
  final PredicateOf0 isVisible;

  ViewProperty({this.flex = 1, this.isVisible});

  Widget get widget;
}

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
