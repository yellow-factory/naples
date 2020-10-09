import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:mustache_template/mustache.dart';
import 'package:naples/view_models/properties/widgets/markdown_widget.dart';
import 'package:naples/view_models/properties/widgets/sized_markdown_widget.dart';
import 'package:provider/provider.dart';
import 'package:navy/navy.dart';
import 'package:naples/view_models/properties/widgets/checkbox_view_model_property_widget.dart';
import 'package:naples/view_models/properties/widgets/comment_view_model_property_widget.dart';
import 'package:naples/view_models/properties/widgets/dropdown_view_model_property_widget.dart';
import 'package:naples/view_models/properties/widgets/file_view_model_property_widget.dart';
import 'package:naples/view_models/properties/widgets/int_view_model_property_widget.dart';
import 'package:naples/view_models/properties/widgets/radio_list_view_model_property_widget.dart';
import 'package:naples/view_models/properties/widgets/string_view_model_property_widget.dart';
import 'package:naples/view_models/properties/widgets/switch_view_model_property_widget.dart';
import 'package:naples/view_models/properties/widgets/datetime_view_model_property_widget.dart';
import 'package:naples/view_models/view_model.dart';
import 'dart:convert';

class CommentProperty extends ViewProperty {
  final FunctionOf0<String> comment;
  final FontStyle fontStyle;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final double topPadding;
  final double bottomPadding;

  CommentProperty(this.comment,
      {int flex = 99,
      PredicateOf0 isVisible,
      this.fontStyle,
      this.textAlign,
      this.fontWeight,
      this.topPadding,
      this.bottomPadding})
      : super(flex: flex, isVisible: isVisible);

  @override
  Widget get widget {
    return ChangeNotifierProvider<CommentProperty>.value(
      value: this,
      child: CommentViewModelPropertyWidget(),
    );
  }
}

class DividerProperty extends ViewProperty {
  DividerProperty({
    int flex = 99,
    PredicateOf0 isVisible,
  }) : super(
          flex: flex,
          isVisible: isVisible,
        );

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

class MarkdownProperty extends ViewProperty {
  final FunctionOf0<String> markdown;
  final double width;
  final double height;

  MarkdownProperty(
    this.markdown, {
    int flex = 99,
    PredicateOf0 isVisible,
    this.width,
    this.height,
  }) : super(
          flex: flex,
          isVisible: isVisible,
        );

  @override
  Widget get widget {
    return ChangeNotifierProvider<MarkdownProperty>.value(
      value: this,
      child: width == null && height == null ? MarkdownWidget() : SizedMarkdownWidget(),
    );
  }
}

class MustacheMarkdownProperty<T> extends MarkdownProperty {
  final T source;

  MustacheMarkdownProperty(
    this.source,
    FunctionOf0 template, {
    int flex = 99,
    PredicateOf0 isVisible,
    double width,
    double height,
  }) : super(
          template,
          flex: flex,
          isVisible: isVisible,
          width: width,
          height: height,
        );

  @override
  FunctionOf0<String> get markdown {
    var template = new Template(super.markdown());
    var transSource = json.decode(json.encode(source));
    var output = template.renderString(transSource);
    return () => output;
  }
}

abstract class TextProperty<U> extends ModelProperty<U> {
  final bool obscureText;
  final int maxLength;

  TextProperty(
    FunctionOf0<U> getProperty, {
    FunctionOf0<String> label,
    FunctionOf0<String> hint,
    int flex = 1,
    bool autofocus = false,
    ActionOf1<U> setProperty,
    PredicateOf0 isVisible,
    PredicateOf0 isEditable,
    FunctionOf1<U, String> isValid,
    this.obscureText: false,
    this.maxLength = -1,
  }) : super(
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
    currentValue = getProperty();
  }

  String get serializedValue {
    if (currentValue == null) return '';
    return currentValue.toString();
  }

  set serializedValue(String value);
}

class StringProperty extends TextProperty<String> {
  StringProperty(
    FunctionOf0<String> getProperty, {
    FunctionOf0<String> label,
    FunctionOf0<String> hint,
    int flex = 1,
    bool autofocus = false,
    ActionOf1<String> setProperty,
    PredicateOf0 isVisible,
    PredicateOf0 isEditable,
    FunctionOf1<String, String> isValid,
    bool obscureText = false,
    int maxLength,
  }) : super(
          getProperty,
          label: label,
          hint: hint,
          flex: flex,
          autofocus: autofocus,
          setProperty: setProperty,
          isVisible: isVisible,
          isEditable: isEditable,
          isValid: isValid,
          obscureText: obscureText,
          maxLength: maxLength,
        );

  @override
  set serializedValue(String value) => currentValue = value;

  @override
  Widget get widget => ChangeNotifierProvider<StringProperty>.value(
      value: this, child: StringViewModelPropertyWidget());
}

class IntProperty extends TextProperty<int> {
  IntProperty(
    FunctionOf0<int> getProperty, {
    FunctionOf0<String> label,
    FunctionOf0<String> hint,
    int flex = 1,
    bool autofocus = false,
    ActionOf1<int> setProperty,
    PredicateOf0 isVisible,
    PredicateOf0 isEditable,
    FunctionOf1<int, String> isValid,
    bool obscureText = false,
    int maxLength,
  }) : super(
          getProperty,
          label: label,
          hint: hint,
          flex: flex,
          autofocus: autofocus,
          setProperty: setProperty,
          isVisible: isVisible,
          isEditable: isEditable,
          isValid: isValid,
          obscureText: obscureText,
          maxLength: maxLength,
        );

  @override
  set serializedValue(String value) {
    if (value == null || value.isEmpty) currentValue = 0;
    currentValue = int.parse(value);
  }

  @override
  Widget get widget =>
      ChangeNotifierProvider<IntProperty>.value(value: this, child: IntViewModelPropertyWidget());
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

class BoolProperty extends ModelProperty<bool> {
  BoolWidgetType widgetType = BoolWidgetType.Checkbox;
  BoolWidgetPosition widgetPosition = BoolWidgetPosition.Trailing;
  FunctionOf1<BoolValues, FunctionOf0<String>> displayName = (t) => () => t.displayName;

  BoolProperty(
    FunctionOf0<bool> getProperty, {
    FunctionOf0<String> label,
    FunctionOf0<String> hint,
    int flex,
    bool autofocus = false,
    ActionOf1<bool> setProperty,
    PredicateOf0 isVisible,
    PredicateOf0 isEditable,
    FunctionOf1<bool, String> isValid,
    this.widgetType,
    this.widgetPosition,
    this.displayName,
  }) : super(
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
    currentValue = this.getProperty() ?? false;
  }

  SelectProperty<bool, BoolValues> toSelect() {
    return SelectProperty<bool, BoolValues>(
      this.getProperty,
      () => BoolValues.values,
      (t) => t.boolValue,
      displayName,
      flex: flex,
      label: label,
      hint: hint,
      autofocus: autofocus,
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
        return ChangeNotifierProvider<BoolProperty>.value(
            value: this, child: SwitchViewModelPropertyWidget());
      case BoolWidgetType.Checkbox:
        return ChangeNotifierProvider<BoolProperty>.value(
            value: this, child: CheckboxViewModelPropertyWidget());
      case BoolWidgetType.Radio:
        return ChangeNotifierProvider.value(
            value: toSelect(), child: RadioListViewModelPropertyWidget<bool, BoolValues>());
      default:
        return ChangeNotifierProvider<BoolProperty>.value(
            value: this, child: CheckboxViewModelPropertyWidget());
    }
  }
}

class FileProperty extends ModelProperty<List<int>> {
  List<int> _value;

  FileProperty(
    FunctionOf0<List<int>> getProperty, {
    FunctionOf0<String> label,
    FunctionOf0<String> hint,
    int flex,
    bool autofocus = false,
    ActionOf1<List<int>> setProperty,
    PredicateOf0 isVisible,
    PredicateOf0 isEditable,
  }) : super(
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
    _value = getProperty();
  }

  @override
  Widget get widget {
    return ChangeNotifierProvider<FileProperty>.value(
        value: this, child: FileViewModelPropertyWidget());
  }
}

//TODO: Crec que hi hauria d'haver un Select i un MultipleSelect per a casos de selecció múltiple
//TODO: En el cas de MultipleSelect les opcions han de ser CheckBox, Chips o algun tipus de Dropdown...
//TODO: Cal comprovar que tots aquests casos Select funcionen correctament per class i per enum amb multiidioma inclòs...

enum SelectWidgetType { DropDown, Radio }

///U defines the type of the property being edited which is a member of T
///V defines the type of the list of items being exposed in the list of options
///In some cases U and V may coincide
class SelectProperty<U, V> extends ModelProperty<U> {
  SelectWidgetType widgetType = SelectWidgetType.DropDown;
  final FunctionOf0<List<V>> listItems;
  final FunctionOf1<V, U> valueMember; //Function to project U from V
  final FunctionOf1<V, FunctionOf0<String>>
      displayMember; //Function to display the member as String

  SelectProperty(
    FunctionOf0<U> getProperty,
    this.listItems,
    this.valueMember,
    this.displayMember, {
    FunctionOf0<String> label,
    FunctionOf0<String> hint,
    int flex,
    bool autofocus = false,
    ActionOf1<U> setProperty,
    PredicateOf0 isVisible,
    PredicateOf0 isEditable,
    FunctionOf1<U, String> isValid,
    this.widgetType,
  }) : super(
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
    currentValue = getProperty();
  }

  @override
  Widget get widget {
    switch (widgetType) {
      case SelectWidgetType.DropDown:
        return ChangeNotifierProvider<SelectProperty<U, V>>.value(
            value: this, child: DropDownViewModelPropertyWidget<U, V>());
      case SelectWidgetType.Radio:
        return ChangeNotifierProvider<SelectProperty<U, V>>.value(
            value: this, child: RadioListViewModelPropertyWidget<U, V>());
      default:
        return ChangeNotifierProvider<SelectProperty<U, V>>.value(
            value: this, child: DropDownViewModelPropertyWidget<U, V>());
    }
  }
}

class DateTimeProperty extends ModelProperty<DateTime> {
  final DateFormat dateFormat;
  final bool onlyDate;
  final DateTime firstDate;
  final DateTime lastDate;

  DateTimeProperty(
    FunctionOf0<DateTime> getProperty, {
    FunctionOf0<String> label,
    FunctionOf0<String> hint,
    int flex = 1,
    bool autofocus = false,
    ActionOf1<DateTime> setProperty,
    PredicateOf0 isVisible,
    PredicateOf0 isEditable,
    FunctionOf1<DateTime, String> isValid,
    this.dateFormat,
    this.onlyDate = false,
    this.firstDate,
    this.lastDate,
  }) : super(
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
  Widget get widget => ChangeNotifierProvider<DateTimeProperty>.value(
      value: this, child: DateTimeViewModelPropertyWidget());

  @override
  void initialize() {
    currentValue = getProperty();
  }
}

//TODO: Falten la resta de tipus: "double", etc.
//       case "double":
//         //En el cas de double i DateTime hauré de fer servir:
//         //https://pub.dev/documentation/intl/latest/intl/NumberFormat-class.html
//         //https://pub.dev/documentation/intl/latest/intl/DateFormat-class.html
//         //https://pub.dev/packages/intl
//         break;

//TODO: Cal implementar el combo i el lookup
