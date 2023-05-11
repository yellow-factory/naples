import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naples/src/common/common.dart';
import 'package:navy/navy.dart';
import 'package:naples/src/edit/properties/model_property.dart';

class IntProperty extends ModelPropertyWidget<int?>
    with ModelPropertyMixin<int?>
    implements Expandable {
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
  final FunctionOf0<int?> getProperty;
  @override
  final ActionOf1<int?>? setProperty;
  @override
  final FunctionOf1<int?, String?>? validator;
  final int? maxLength;
  final bool obscureText;

  IntProperty({
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
    this.maxLength,
  }) : super(key: key);

  int? _getValue(String? x) => x == null ? null : int.tryParse(x);

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
      //validator: ifNotNullFunctionOf1(validator, (FunctionOf1<int?, String?> f) => (x) => f(_getValue(x)), null), --> Another way of saying the same, but longer because of lack of inferation
      validator: validator == null ? null : (x) => validator!(_getValue(x)),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(maxLength),
      ],
      obscureText: obscureText,
      onSaved: setProperty == null ? null : (x) => setProperty!(_getValue(x)),
      // minLines: 1,
      // maxLines: 3,
    );
  }
}
