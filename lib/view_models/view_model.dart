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

abstract class LayoutMember extends ChangeNotifier {
  final int flex;

  LayoutMember({this.flex = 1});

  Widget get widget;
}

abstract class IsVisibleMember extends LayoutMember {
  final PredicateOf0 isVisible;
  IsVisibleMember({int flex = 1, this.isVisible}) : super(flex: flex);
}

abstract class IsEditableMember extends IsVisibleMember {
  final PredicateOf0 isEditable;
  IsEditableMember({int flex = 1, PredicateOf0 isVisible, this.isEditable})
      : super(isVisible: isVisible, flex: flex);
}

abstract class ViewModelProperty<U> extends IsEditableMember {
  //Pel que fa al control TextEditingController, té dues propietats: enabled i readonly,
  //que semblaria que fan coses similars i antagòniques però no es comporten del tot igual
  //Mentre enabled=false no permet el focus al control readonly=true sí que ho permet
  //Tant enabled=false com readonly=true bloquegen l'escriptura en general, però amb readonly=true
  //algunes coses com copiar, retallar o suprimir cap a la dreta estan permeses en aquesta versió (potser és un bug)
  //En el nostre cas crec que no cal fer la distinció, per això tractarem simplement la propietat editable
  //Pel que fa al control farem servir normalment enabled i no farem servir readonly

  //Es podria fer servir el onSave per realitzar el setProperty, però no estic segur si és la millor opció
  //https://forum.freecodecamp.org/t/how-to-validate-forms-and-user-input-the-easy-way-using-flutter/190377

  final FunctionOf0<String> label;
  final FunctionOf0<String> hint;
  final FunctionOf0<U> getProperty;
  final bool autofocus;
  final ActionOf1<U> setProperty;
  final PredicateOf0 isEditable;
  final FunctionOf1<U, String> isValid;

  ViewModelProperty(this.getProperty,
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
