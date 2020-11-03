import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:navy/navy.dart';
import 'package:naples/src/view_models/edit/properties/model_property.dart';

class IntProperty extends ModelProperty<int> {
  final int maxLength;
  final bool obscureText;

  IntProperty({
    FunctionOf0<int> getProperty,
    String label,
    String hint,
    int flex = 1,
    bool autofocus = false,
    ActionOf1<int> setProperty,
    PredicateOf0 isEditable,
    FunctionOf1<int, String> isValid,
    this.obscureText = false,
    this.maxLength,
  }) : super(
          getProperty: getProperty,
          label: label,
          hint: hint,
          flex: flex,
          autofocus: autofocus,
          setProperty: setProperty,
          isEditable: isEditable,
          isValid: isValid,
        );

  int _getValue(String x) => int.tryParse(x);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: (getProperty() ?? 0).toString(),
      decoration: InputDecoration(
        //filled: true,
        hintText: hint,
        labelText: label,
      ),
      enabled: isEditable == null ? true : isEditable(),
      autofocus: autofocus ?? false,
      validator: isValid == null ? null : (x) => isValid(_getValue(x)),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(maxLength),
      ],
      obscureText: obscureText,
      onSaved: setProperty == null ? null : (x) => setProperty(_getValue(x)),
      // minLines: 1,
      // maxLines: 3,
    );
  }
}
