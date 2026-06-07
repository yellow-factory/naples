import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naples/src/common/common.dart';
import 'package:naples/src/widgets/boxed_text_form_field.dart';
import 'package:navy/navy.dart';
import 'package:naples/src/edit/properties/property.dart';

class IntProperty extends PropertyWidget<int?> with PropertyMixin<int?> implements Expandable {
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

  /// Inline help shown below the control when the global help toggle is on.
  final String? help;

  /// Render the value in a monospace face.
  final bool mono;

  /// Optional unit shown inside the box after the value (e.g. `€`).
  final String? unitSuffix;

  IntProperty({
    super.key,
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
    this.help,
    this.mono = false,
    this.unitSuffix,
  });

  int? _getValue(String? x) => x == null ? null : int.tryParse(x);

  @override
  Widget build(BuildContext context) {
    final roLook = !enabled;

    return BoxedTextFormField(
      label: label,
      help: help,
      hintText: hint,
      readOnlyLook: roLook,
      autofocus: autofocus,
      obscureText: obscureText,
      mono: mono,
      unitSuffix: unitSuffix,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(maxLength),
      ],
      initialValue: (getProperty() ?? 0).toString(),
      validator: validator == null ? null : (x) => validator!(_getValue(x)),
      onSaved: setProperty == null ? null : (x) => setProperty!(_getValue(x)),
    );
  }
}
