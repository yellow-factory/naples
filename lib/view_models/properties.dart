import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:yellow_naples/utils.dart';
import 'package:yellow_naples/view_models/property_widgets/checkbox_view_model_property_widget.dart';
import 'package:yellow_naples/view_models/property_widgets/comment_view_model_property_widget.dart';
import 'package:yellow_naples/view_models/property_widgets/dropdown_view_model_property_widget.dart';
import 'package:yellow_naples/view_models/property_widgets/file_view_model_property_widget.dart';
import 'package:yellow_naples/view_models/property_widgets/int_view_model_property_widget.dart';
import 'package:yellow_naples/view_models/property_widgets/radio_list_view_model_property_widget.dart';
import 'package:yellow_naples/view_models/property_widgets/string_view_model_property_widget.dart';
import 'package:yellow_naples/view_models/property_widgets/switch_view_model_property_widget.dart';
import 'package:yellow_naples/view_models/view_model.dart';

class CommentLayoutMember<T> extends IsVisibleMember<T> {
  final FunctionOf<String> comment;
  final FontStyle fontStyle;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final double topPadding;
  final double bottomPadding;

  CommentLayoutMember(ViewModel viewModel, T source, this.comment,
      {int flex = 99,
      Predicate1<T> isVisible,
      this.fontStyle,
      this.textAlign,
      this.fontWeight,
      this.topPadding,
      this.bottomPadding})
      : super(viewModel, source, flex: flex, isVisible: isVisible);

  @override
  Widget get widget {
    return ChangeNotifierProvider<CommentLayoutMember>.value(
        value: this, child: CommentViewModelPropertyWidget());
  }
}

class DividerLayoutMember extends LayoutMember {
  DividerLayoutMember(ViewModel viewModel, {int flex = 99}) : super(viewModel, flex: flex);

  @override
  Widget get widget => Divider();

//TODO: Cal separar el widget com en la resta de casos
//TODO: Es podrien afegir algunes propietats per fer-lo més ric, com en el cas del CommentLayoutMember: topPadding, bottomPadding,etc.
  // const Divider(
  //           color: Colors.black,
  //           height: 20,
  //           thickness: 5,
  //           indent: 20,
  //           endIndent: 0,
  //         ),

}

abstract class TextViewModelProperty<T, U> extends ViewModelProperty<T, U> {
  String _value;

  TextViewModelProperty(
      ViewModel viewModel, FunctionOf<String> label, T source, FunctionOf1<T, U> getProperty,
      {FunctionOf<String> hint,
      int flex,
      bool autofocus,
      ActionOf2<T, U> setProperty,
      Predicate1<T> isVisible,
      Predicate1<T> isEditable,
      FunctionOf1<U, String> isValid})
      : super(viewModel, source, getProperty,
            label: label,
            hint: hint,
            flex: flex,
            autofocus: autofocus,
            setProperty: setProperty,
            isVisible: isVisible,
            isEditable: isEditable,
            isValid: isValid);

  @override
  void initialize() {
    _value = serialize(getProperty(source));
  }

  String serialize(U value) {
    if (value == null) return '';
    return value.toString();
  }

  U deserialize(String value);

  @override
  U get currentValue => deserialize(_value);

  @override
  set currentValue(U value) {
    _value = serialize(value);
  }
}

class StringViewModelProperty<T> extends TextViewModelProperty<T, String> {
  StringViewModelProperty(
      ViewModel viewModel, FunctionOf<String> label, T source, FunctionOf1<T, String> getProperty,
      {FunctionOf<String> hint,
      int flex,
      bool autofocus,
      ActionOf2<T, String> setProperty,
      Predicate1<T> isVisible,
      Predicate1<T> isEditable,
      FunctionOf1<String, String> isValid})
      : super(viewModel, label, source, getProperty,
            hint: hint,
            flex: flex,
            autofocus: autofocus,
            setProperty: setProperty,
            isVisible: isVisible,
            isEditable: isEditable,
            isValid: isValid);

  @override
  String deserialize(String value) => value;

  @override
  Widget get widget => ChangeNotifierProvider<StringViewModelProperty>.value(
      value: this, child: StringViewModelPropertyWidget());
}

class IntViewModelProperty<T> extends TextViewModelProperty<T, int> {
  IntViewModelProperty(
    ViewModel viewModel,
    FunctionOf<String> label,
    T source,
    FunctionOf1<T, int> getProperty, {
    FunctionOf<String> hint,
    int flex,
    bool autofocus,
    ActionOf2<T, int> setProperty,
    Predicate1<T> isVisible,
    Predicate1<T> isEditable,
    FunctionOf1<int, String> isValid,
  }) : super(
          viewModel,
          label,
          source,
          getProperty,
          hint: hint,
          flex: flex,
          autofocus: autofocus,
          setProperty: setProperty,
          isVisible: isVisible,
          isEditable: isEditable,
          isValid: isValid,
        );

  @override
  int deserialize(String value) {
    if (value == null) return 0;
    if (value.isEmpty) return 0;
    return int.parse(value);
  }

  @override
  Widget get widget => ChangeNotifierProvider<IntViewModelProperty>.value(
      value: this, child: IntViewModelPropertyWidget());
}

enum BoolWidgetType { Switch, Checkbox, Radio }
enum BoolWidgetPosition { Leading, Trailing }
enum BoolValues { True, False }

extension BoolValuesExtension on BoolValues {
  bool get boolValue {
    if (this == BoolValues.True) return true;
    return false;
  }

  String get displayName => describeEnum(this);
}

//TODO: El String de isValid hauria de ser una funció que retonés String per tal que fos localitzable

class BoolViewModelProperty<T> extends ViewModelProperty<T, bool> {
  BoolWidgetType widgetType = BoolWidgetType.Checkbox;
  BoolWidgetPosition widgetPosition = BoolWidgetPosition.Trailing;
  FunctionOf1<BoolValues, FunctionOf<String>> displayName = (t) => () => t.displayName;

  BoolViewModelProperty(
    ViewModel viewModel,
    FunctionOf<String> label,
    T source,
    FunctionOf1<T, bool> getProperty, {
    FunctionOf<String> hint,
    int flex,
    bool autofocus,
    ActionOf2<T, bool> setProperty,
    Predicate1<T> isVisible,
    Predicate1<T> isEditable,
    FunctionOf1<bool, String> isValid,
    this.widgetType,
    this.widgetPosition,
    this.displayName,
  }) : super(
          viewModel,
          source,
          getProperty,
          label: label,
          hint: hint,
          flex: flex,
          autofocus: autofocus,
          setProperty: setProperty,
          isVisible: isVisible,
          isEditable: isEditable,
          isValid: isValid,
        );

  @override
  void initialize() {
    currentValue = this.getProperty(source) ?? false;
  }

  SelectViewModelProperty<T, bool, BoolValues> toSelect() {
    return SelectViewModelProperty<T, bool, BoolValues>(
      viewModel,
      label,
      source,
      this.getProperty,
      () => BoolValues.values,
      (t) => t.boolValue,
      displayName,
      flex: flex,
      autofocus: autofocus,
      hint: hint,
      isEditable: isEditable,
      isValid: isValid,
      setProperty: setProperty,
      widgetType: SelectWidgetType.Radio,
    );
  }

  @override
  Widget get widget {
    switch (widgetType) {
      case BoolWidgetType.Switch:
        return ChangeNotifierProvider<BoolViewModelProperty>.value(
            value: this, child: SwitchViewModelPropertyWidget());
      case BoolWidgetType.Checkbox:
        return ChangeNotifierProvider<BoolViewModelProperty>.value(
            value: this, child: CheckboxViewModelPropertyWidget());
      case BoolWidgetType.Radio:
        var select = toSelect();
        return ChangeNotifierProvider.value(
            value: select, child: RadioListViewModelPropertyWidget<T, bool, BoolValues>());
      default:
        return ChangeNotifierProvider<BoolViewModelProperty>.value(
            value: this, child: CheckboxViewModelPropertyWidget());
    }
  }
}

class FileViewModelProperty<T> extends ViewModelProperty<T, List<int>> {
  List<int> _value;

  FileViewModelProperty(
    ViewModel viewModel,
    FunctionOf<String> label,
    T source,
    FunctionOf1<T, List<int>> getProperty, {
    FunctionOf<String> hint,
    int flex,
    bool autofocus,
    ActionOf2<T, List<int>> setProperty,
    Predicate1<T> isVisible,
    Predicate1<T> isEditable,
    Predicate1<T> isRequired,
  }) : super(
          viewModel,
          source,
          getProperty,
          label: label,
          hint: hint,
          flex: flex,
          autofocus: autofocus,
          setProperty: setProperty,
          isVisible: isVisible,
          isEditable: isEditable,
        );

  @override
  List<int> get currentValue => _value;

  @override
  void initialize() {
    _value = getProperty(source);
  }

  @override
  Widget get widget {
    return ChangeNotifierProvider<FileViewModelProperty>.value(
        value: this, child: FileViewModelPropertyWidget());
  }
}

//TODO: Crec que hi hauria d'haver un Select i un MultipleSelect per a casos de selecció múltiple
//TODO: En el cas de MultipleSelect les opcions han de ser CheckBox, Chips o algun tipus de Dropdown...
//TODO: Cal comprovar que tots aquests casos Select funcionen correctament per class i per enum amb multiidioma inclòs...

enum SelectWidgetType { DropDown, Radio }

///T defines the type of the class being edited which has a property defined by this class
///U defines the type of the property being edited which is a member of T
///V defines the type of the list of items being exposed in the list of options
///In some cases U and V may coincide
class SelectViewModelProperty<T, U, V> extends ViewModelProperty<T, U> {
  SelectWidgetType widgetType = SelectWidgetType.DropDown;
  final FunctionOf<List<V>> listItems;
  final FunctionOf1<V, U> valueMember; //Function to project U from V
  final FunctionOf1<V, FunctionOf<String>> displayMember; //Function to display the member as String

  SelectViewModelProperty(
    ViewModel viewModel,
    FunctionOf<String> label,
    T source,
    FunctionOf1<T, U> getProperty,
    this.listItems,
    this.valueMember,
    this.displayMember, {
    FunctionOf<String> hint,
    int flex,
    bool autofocus,
    ActionOf2<T, U> setProperty,
    Predicate1<T> isVisible,
    Predicate1<T> isEditable,
    FunctionOf1<U, String> isValid,
    this.widgetType,
  }) : super(
          viewModel,
          source,
          getProperty,
          label: label,
          hint: hint,
          flex: flex,
          autofocus: autofocus,
          setProperty: setProperty,
          isVisible: isVisible,
          isEditable: isEditable,
          isValid: isValid,
        );

  @override
  void initialize() {
    currentValue = getProperty(source);
  }

  @override
  Widget get widget {
    switch (widgetType) {
      case SelectWidgetType.DropDown:
        return ChangeNotifierProvider<SelectViewModelProperty<T, U, V>>.value(
            value: this, child: DropDownViewModelPropertyWidget<T, U, V>());
      case SelectWidgetType.Radio:
        return ChangeNotifierProvider<SelectViewModelProperty<T, U, V>>.value(
            value: this, child: RadioListViewModelPropertyWidget<T, U, V>());
      default:
        return ChangeNotifierProvider<SelectViewModelProperty<T, U, V>>.value(
            value: this, child: DropDownViewModelPropertyWidget<T, U, V>());
    }
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
