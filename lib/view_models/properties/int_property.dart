import 'package:flutter/material.dart';
import 'package:naples/view_models/properties/text_property.dart';
import 'package:naples/view_models/properties/widgets/int_view_model_property_widget.dart';
import 'package:navy/navy.dart';
import 'package:provider/provider.dart';

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
