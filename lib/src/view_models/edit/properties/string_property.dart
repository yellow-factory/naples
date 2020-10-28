import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:navy/navy.dart';
import 'package:naples/src/view_models/edit/properties/model_property.dart';

class StringProperty extends ModelProperty<String> {
  final bool obscureText;
  final int maxLength;

  StringProperty({
    @required FunctionOf0<String> getProperty,
    String label,
    String hint,
    int flex = 1,
    bool autofocus = false,
    ActionOf1<String> setProperty,
    PredicateOf0 isEditable,
    FunctionOf1<String, String> isValid,
    this.obscureText = false,
    this.maxLength,
    Key key,
  }) : super(
          getProperty: getProperty,
          label: label,
          hint: hint,
          flex: flex,
          autofocus: autofocus,
          setProperty: setProperty,
          isEditable: isEditable,
          isValid: isValid,
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: getProperty(),
      decoration: InputDecoration(
        //filled: true,
        hintText: hint,
        labelText: label,
      ),
      enabled: isEditable == null ? true : isEditable(),
      autofocus: autofocus,
      validator: isValid,
      obscureText: obscureText,
      //maxLength: property.maxLength,
      inputFormatters: [
        LengthLimitingTextInputFormatter(maxLength),
      ],

      // minLines: 1,
      // maxLines: 3,
      onSaved: setProperty,
    );
  }
}
