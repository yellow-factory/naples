import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yellow_naples/utils.dart';
import 'package:yellow_naples/view_models/properties_widgets/checkbox_view_model_property_widget.dart';
import 'package:yellow_naples/view_models/properties_widgets/dropdown_view_model_property_widget.dart';
import 'package:yellow_naples/view_models/properties_widgets/file_view_model_property_widget.dart';
import 'package:yellow_naples/view_models/properties_widgets/switch_view_model_property_widget.dart';
import 'package:yellow_naples/view_models/properties_widgets/text_view_model_property_widget.dart';
import 'package:yellow_naples/view_models/view_model.dart';

abstract class TextViewModelProperty<T, U> extends EditableViewModelProperty<T, U> {
  final controller = TextEditingController();

  TextViewModelProperty(FunctionOf<String> label, T source, FunctionOf1<T, U> getProperty,
      {FunctionOf<String> hint,
      int flex,
      bool autofocus,
      ActionOf2<T, U> setProperty,
      Predicate1<T> isEditable,
      Predicate1<T> isRequired,
      FunctionOf1<U, String> isValid})
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
    controller.text = serialize(getProperty(source));
  }

  String serialize(U value) {
    if (value == null) return '';
    return value.toString();
  }

  U deserialize(String value);

  @override
  U get currentValue => deserialize(controller.text);

  @override
  set currentValue(U value) {
    controller.text = serialize(value);
  }
}

class StringViewModelProperty<T> extends TextViewModelProperty<T, String> {
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
  String deserialize(String value) => value;

  @override
  bool isEmpty(String value) => value == null || value.isEmpty;

  @override
  Widget get widget => TextViewModelPropertyWidget(this);
}

class IntViewModelProperty<T> extends TextViewModelProperty<T, int> {
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
  int deserialize(String value) {
    if (value == null) return 0;
    if (value.isEmpty) return 0;
    return int.parse(value);
  }

  @override
  bool isEmpty(int value) => value == null || value == 0;

  @override
  Widget get widget =>
      TextViewModelPropertyWidget(this, type: TextViewModelPropertyWidgetType.Number);
}

enum BoolWidgetType { Switch, Checkbox }
enum BoolWidgetPosition { Leading, Trailing }

class BoolViewModelProperty<T> extends EditableViewModelProperty<T, bool> {
  final BoolWidgetType widgetType;
  final BoolWidgetPosition widgetPosition;

  BoolViewModelProperty(FunctionOf<String> label, T source, FunctionOf1<T, bool> getProperty,
      {FunctionOf<String> hint,
      int flex,
      bool autofocus,
      ActionOf2<T, bool> setProperty,
      Predicate1<T> isEditable,
      Predicate1<T> isRequired,
      FunctionOf1<bool, String> isValid,
      this.widgetType = BoolWidgetType.Checkbox,
      this.widgetPosition = BoolWidgetPosition.Trailing})
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
    currentValue = this.getProperty(source) ?? false;
  }

  @override
  bool isEmpty(bool value) => value == null;

  @override
  Widget get widget {
    switch (widgetType) {
      case BoolWidgetType.Switch:
        return SwitchViewModelPropertyWidget(this);
      case BoolWidgetType.Checkbox:
        return CheckboxViewModelPropertyWidget(this);
      default:
        return CheckboxViewModelPropertyWidget(this);
    }
  }
}

class FileViewModelProperty<T> extends EditableViewModelProperty<T, List<int>> {
  List<int> _value;

  FileViewModelProperty(FunctionOf<String> label, T source, FunctionOf1<T, List<int>> getProperty,
      {FunctionOf<String> hint,
      int flex,
      bool autofocus,
      ActionOf2<T, List<int>> setProperty,
      Predicate1<T> isEditable,
      Predicate1<T> isRequired})
      : super(label, source, getProperty,
            hint: hint,
            flex: flex,
            autofocus: autofocus,
            setProperty: setProperty,
            isEditable: isEditable,
            isRequired: isRequired);

  @override
  List<int> get currentValue => _value;

  @override
  void initialize() {
    _value = getProperty(source);
  }

  @override
  Widget get widget {
    return FileViewModelPropertyWidget(this);
  }
}

class SelectViewModelProperty<T, U> extends EditableViewModelProperty<T, U> {
//TODO: Hi hauria d'haver un paràmetre més perquè els items de la llista no tenen perquè ser de tipus U

  U _value;
  FunctionOf<List<U>> listItems;

  SelectViewModelProperty(
      FunctionOf<String> label, T source, FunctionOf1<T, U> getProperty, this.listItems,
      {FunctionOf<String> hint,
      int flex,
      bool autofocus,
      ActionOf2<T, U> setProperty,
      Predicate1<T> isEditable,
      Predicate1<T> isRequired,
      FunctionOf1<U, String> isValid})
      : super(label, source, getProperty,
            hint: hint,
            flex: flex,
            autofocus: autofocus,
            setProperty: setProperty,
            isEditable: isEditable,
            isRequired: isRequired,
            isValid: isValid);

  @override
  U get currentValue => _value;

  @override
  void initialize() {
    _value = getProperty(source);
  }

  @override
  Widget get widget {
    return DropDownViewModelPropertyWidget<T, U>(this);
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
