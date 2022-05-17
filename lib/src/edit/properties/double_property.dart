import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naples/src/common/common.dart';
import 'package:navy/navy.dart';
import 'package:naples/src/edit/properties/model_property.dart';

class DoubleProperty extends StatelessWidget with ModelProperty<double?>, Expandable {
  @override
  final int flex;
  @override
  final String label;
  @override
  final String? hint;
  @override
  final bool autofocus;
  @override
  final PredicateOf0? editable;
  @override
  final FunctionOf0<double?> getProperty;
  @override
  final ActionOf1<double?>? setProperty;
  @override
  final FunctionOf1<double?, String?>? validator;
  final bool obscureText;

  DoubleProperty({
    Key? key,
    required this.label,
    this.hint,
    this.autofocus = false,
    this.editable,
    required this.getProperty,
    this.setProperty,
    this.validator,
    this.flex = 1,
    this.obscureText = false,
  }) : super(key: key);

  double? _getValue(String? x) => x == null ? null : double.tryParse(x);

  String? _validator(String? value) {
    if (value == null) return null;
    if (value.isEmpty) return null;
    var parsedValue = _getValue(value);
    if (parsedValue == null) return 'Invalid Number'; //TODO: Localize
    if (validator == null) return null;
    return validator!(parsedValue);
  }

  //TODO: Facilitate NumberFormat to format and parse the double

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: (getProperty() ?? 0).toString(),
      decoration: InputDecoration(
        //filled: true,
        hintText: hint,
        labelText: label,
      ),
      enabled: enabled,
      autofocus: autofocus,
      validator: (x) => _validator(x),
      //validator: validator == null ? null : (x) => validator!(_getValue(x)),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.singleLineFormatter,
        FilteringTextInputFormatter.allow(
          RegExp(r'[0-9.,E\-]'),
        ),
      ],
      obscureText: obscureText,
      onSaved: setProperty == null ? null : (x) => setProperty!(_getValue(x)),
    );
  }
}
