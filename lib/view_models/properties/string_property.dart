import 'package:flutter/material.dart';
import 'package:naples/view_models/properties/text_property.dart';
import 'package:naples/view_models/properties/widgets/string_view_model_property_widget.dart';
import 'package:navy/navy.dart';
import 'package:provider/provider.dart';

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
