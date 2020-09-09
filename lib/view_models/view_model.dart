import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yellow_naples/initialize.dart';
import 'package:yellow_naples/utils.dart';

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

  FunctionOf<String> get title;

  /// El NavigationWidget enregistra un provider de tipus ViewModel que el
  /// widget que es retorni aquí pot recuperar. Tot i així si es vol utilitzar
  /// una subclasse de ViewModel, serà necessària enregistrar-la i passar-la de
  /// nou amb el widget.
  Widget get widget;
}

abstract class ViewModelProperty<T, U> {
  final FunctionOf<String> label;
  final FunctionOf<String> hint;
  final T source;
  final FunctionOf1<T, U> getProperty;
  final int flex;

  ViewModelProperty(this.label, this.source, this.getProperty, {this.hint, this.flex = 1});

  Widget get widget;
}

abstract class EditableViewModelProperty<T, U> extends ViewModelProperty<T, U> {
  //Pel que fa al control TextEditingController, té dues propietats: enabled i readonly,
  //que semblaria que fan coses similars i antagoniques però no es comporten del tot igual
  //Mentre enabled=false no permet el focus al control readonly=true sí que ho permet
  //Tant enabled=false com readonly=true bloquegen l'escriptura en general, però amb readonly=true
  //algunes coses com copiar, retallar o suprimir cap a la dreta estan permeses en aquesta versió (potser és un bug)
  //En el nostre cas crec que no cal fer la distinció, per això tractarem simplement la propietat editable
  //Pel que fa al control farem servir normalment enabled i no farem servir readonly

  //Es podria fer servir el onSave per realitzar el setProperty, però no estic segur si és la millor opció
  //https://forum.freecodecamp.org/t/how-to-validate-forms-and-user-input-the-easy-way-using-flutter/190377

  final bool autofocus;
  final ActionOf2<T, U> setProperty;
  final Predicate1<T> isRequired;
  final Predicate1<T> isEditable;
  final FunctionOf1<U, String> isValid;

  EditableViewModelProperty(FunctionOf<String> label, T source, FunctionOf1<T, U> getProperty,
      {FunctionOf<String> hint,
      int flex,
      this.autofocus = false,
      this.setProperty,
      this.isEditable,
      this.isRequired,
      this.isValid})
      : super(label, source, getProperty, hint: hint, flex: flex) {
    initialize();
  }

  void initialize();

  bool get editable => isEditable != null ? isEditable(source) : this.setProperty != null;

  bool get required => isRequired != null ? isRequired(source) : false;

  bool isEmpty(U value) => value == null;

  String validate() {
    String result = '';
    if (required && isEmpty(currentValue)) result += 'Please enter some text';
    if (isValid != null) {
      var valid = isValid(currentValue);
      if (valid != null) result += valid;
    }
    if (result.isEmpty) return null;
    return result;
  }

  U currentValue;

  bool get valid => validate() == null;
  void update() {
    if (this.setProperty == null) throw Exception("setProperty not set");
    this.setProperty(source, currentValue);
  }

  void undo() {
    initialize();
  }
}
