import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:yellow_naples/initialize.dart';
import '../utils.dart';

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

abstract class GetSetViewModel<T> extends ViewModel {
  final _properties = List<EditableViewModelProperty>();
  T model;

  Iterable<EditableViewModelProperty> get properties => _properties;

  void _add(EditableViewModelProperty property) {
    _properties.add(property);
  }

  @override
  Future<void> init1(BuildContext context) async {
    super.init1(context);
    model = await get();
    addProperties();
  }

  void addProperties() {
    _properties.clear();
    notifyListeners();
  }

  Future<T> get();
  Future<void> set();

  void addStringProperty(FunctionOf<String> label, FunctionOf1<T, String> getProperty,
      {FunctionOf<String> hint,
      int flex,
      bool autofocus = false,
      ActionOf2<T, String> setProperty,
      Predicate1<T> isRequired,
      Predicate1<T> isEditable,
      FunctionOf1<String, String> isValid}) {
    _add(StringViewModelProperty<T>(label, model, getProperty,
        hint: hint,
        flex: flex,
        autofocus: autofocus,
        setProperty: setProperty,
        isRequired: isRequired,
        isEditable: isEditable,
        isValid: isValid));
  }

  void addIntProperty(FunctionOf<String> label, FunctionOf1<T, int> getProperty,
      {FunctionOf<String> hint,
      int flex,
      bool autofocus = false,
      ActionOf2<T, int> setProperty,
      Predicate1<T> isRequired,
      Predicate1<T> isEditable,
      FunctionOf1<int, String> isValid}) {
    _add(IntViewModelProperty<T>(label, model, getProperty,
        hint: hint,
        flex: flex,
        autofocus: autofocus,
        setProperty: setProperty,
        isRequired: isRequired,
        isEditable: isEditable,
        isValid: isValid));
  }

  void addBoolProperty(FunctionOf<String> label, FunctionOf1<T, bool> getProperty,
      {FunctionOf<String> hint,
      int flex,
      bool autofocus = false,
      ActionOf2<T, bool> setProperty,
      Predicate1<T> isRequired,
      Predicate1<T> isEditable,
      FunctionOf1<bool, String> isValid,
      BoolWidget boolWidget}) {
    _add(BoolViewModelProperty<T>(label, model, getProperty,
        hint: hint,
        flex: flex,
        autofocus: autofocus,
        setProperty: setProperty,
        isRequired: isRequired,
        isEditable: isEditable,
        isValid: isValid,
        boolWidget: boolWidget));
  }

  bool get valid {
    return properties.every((x) => x.valid);
  }

  void update() {
    //Sends widgets info to model
    properties.where((x) => x.editable).forEach((x) {
      x.update();
    });
  }

  void undo() {
    //Sends model info to widgets, reverse of update
    properties.where((x) => x.editable).forEach((x) {
      x.undo();
    });
  }
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

  String validate(U value) {
    String result = '';
    if (required && isEmpty(value)) result += 'Please enter some text';
    if (isValid != null) {
      var valid = isValid(value);
      if (valid != null) result += valid;
    }
    if (result.isEmpty) return null;
    return result;
  }

  U get currentValue;
  bool get valid => validate(currentValue) == null;
  void update() {
    if (this.setProperty == null) throw Exception("setProperty not set");
    this.setProperty(source, currentValue);
  }

  void undo() {
    initialize();
  }
}

class StringViewModelProperty<T> extends EditableViewModelProperty<T, String> {
  final _controller = TextEditingController();

  StringViewModelProperty(FunctionOf<String> label, T source, FunctionOf1<T, String> getProperty,
      {FunctionOf<String> hint,
      int flex,
      bool autofocus,
      ActionOf2<T, String> setProperty,
      Predicate1<T> isEditable,
      Predicate1<T> isRequired,
      FunctionOf1<String, String> isValid})
      : super(label, source, getProperty,
            hint: hint,
            flex: flex,
            autofocus: autofocus,
            setProperty: setProperty,
            isEditable: isEditable,
            isRequired: isRequired,
            isValid: isValid);

  @override
  void initialize() {
    _controller.text = getProperty(source);
  }

  @override
  String get currentValue => _controller.text;

  @override
  bool isEmpty(String value) => value == null || value.isEmpty;

  Widget get widget {
    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: hint != null ? hint() : null,
        labelText: label(),
      ),
      enabled: editable,
      autofocus: autofocus,
      validator: validate,
    );
  }
}

class IntViewModelProperty<T> extends EditableViewModelProperty<T, int> {
  final _controller = TextEditingController();

  IntViewModelProperty(FunctionOf<String> label, T source, FunctionOf1<T, int> getProperty,
      {FunctionOf<String> hint,
      int flex,
      bool autofocus,
      ActionOf2<T, int> setProperty,
      Predicate1<T> isEditable,
      Predicate1<T> isRequired,
      FunctionOf1<int, String> isValid})
      : super(label, source, getProperty,
            hint: hint,
            flex: flex,
            autofocus: autofocus,
            setProperty: setProperty,
            isEditable: isEditable,
            isRequired: isRequired,
            isValid: isValid);

  @override
  void initialize() {
    var value = this.getProperty(source) ?? 0;
    _controller.text = value.toString();
  }

  @override
  int get currentValue {
    if (_controller.text == null) return 0;
    if (_controller.text.isEmpty) return 0;
    return int.parse(_controller.text);
  }

  @override
  bool isEmpty(int value) => value == null || value == 0;

  @override
  Widget get widget {
    return TextFormField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: hint != null ? hint() : null,
          labelText: label(),
        ),
        enabled: editable,
        autofocus: autofocus,
        validator: (_) {
          return validate(currentValue);
        },
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]);
  }
}

enum BoolWidget { Switch, CheckboxRight, CheckboxLeft }

class BoolViewModelProperty<T> extends EditableViewModelProperty<T, bool> {
  final BoolWidget boolWidget;

  BoolViewModelProperty(FunctionOf<String> label, T source, FunctionOf1<T, bool> getProperty,
      {FunctionOf<String> hint,
      int flex,
      bool autofocus,
      ActionOf2<T, bool> setProperty,
      Predicate1<T> isEditable,
      Predicate1<T> isRequired,
      FunctionOf1<bool, String> isValid,
      this.boolWidget = BoolWidget.CheckboxRight})
      : super(label, source, getProperty,
            hint: hint,
            flex: flex,
            autofocus: autofocus,
            setProperty: setProperty,
            isEditable: isEditable,
            isRequired: isRequired,
            isValid: isValid);

  @override
  void initialize() {}

  @override
  bool get currentValue {
    return this.getProperty(source) ?? false;
  }

  @override
  bool isEmpty(bool value) => value == null;

  @override
  Widget get widget {
    switch (boolWidget) {
      case BoolWidget.Switch:
        return _getSwitch();
      case BoolWidget.CheckboxLeft:
        return _getCheckBoxListTile(ListTileControlAffinity.leading);
      default:
        return _getCheckBoxListTile(ListTileControlAffinity.trailing);
    }
  }

  Widget _getSwitch() {
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return SwitchListTile(
          title: Text(
            label(),
          ),
          value: currentValue,
          onChanged: editable
              ? (value) {
                  setState(() {
                    this.setProperty(source, value);
                  });
                }
              : null,
          autofocus: autofocus,
          contentPadding: EdgeInsets.zero
          // activeTrackColor: Colors.lightGreenAccent,
          // activeColor: Colors.green,

          );
    });
  }

  Widget _getCheckBoxListTile(ListTileControlAffinity controlAffinity) {
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return CheckboxListTile(
          title: Text(label()),
          controlAffinity: controlAffinity,
          value: currentValue,
          onChanged: editable
              ? (value) {
                  setState(() {
                    this.setProperty(source, value);
                  });
                }
              : null,
          autofocus: autofocus,
          contentPadding: EdgeInsets.zero);
    });
  }
}

//TODO: Falten la resta de tipus: "double", "DateTime", etc.
//       case "double":
//         //En el cas de double i DateTime hauré de fer servir:
//         //https://pub.dev/documentation/intl/latest/intl/NumberFormat-class.html
//         //https://pub.dev/documentation/intl/latest/intl/DateFormat-class.html
//         //https://pub.dev/packages/intl
//         break;
//       //En el cas del DateTime, es pot mostrar el tostring en text en el locale que toqui
//       //i un botó per tal que pugui fer el showDateTimePicker i es pugui canviar...

//TODO: Cal implementar el combo i el lookup, em podria guiar per la implementació ja existent a IAS-Docència
