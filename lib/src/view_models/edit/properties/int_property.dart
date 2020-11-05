import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naples/src/common/common.dart';
import 'package:navy/navy.dart';
import 'package:naples/src/view_models/edit/properties/model_property.dart';

class IntProperty extends StatelessWidget with ModelProperty<int>, Expandable {
  final int flex;
  final String label;
  final String hint;
  final bool autofocus;
  final PredicateOf0 editable;
  final FunctionOf0<int> getProperty;
  final ActionOf1<int> setProperty;
  final FunctionOf1<int, String> validator;
  final int maxLength;
  final bool obscureText;

  IntProperty({
    Key key,
    this.label,
    this.hint,
    this.autofocus = false,
    this.editable,
    @required this.getProperty,
    this.setProperty,
    this.validator,
    this.flex = 1,
    this.obscureText = false,
    this.maxLength,
  }) : super(key: key);

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
      enabled: editable == null ? true : editable(),
      autofocus: autofocus ?? false,
      validator: validator == null ? null : (x) => validator(_getValue(x)),
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
