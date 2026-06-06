import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naples/src/common/common.dart';
import 'package:naples/src/common/field_tokens.dart';
import 'package:naples/src/widgets/field_box.dart';
import 'package:naples/src/widgets/field_scaffold.dart';
import 'package:navy/navy.dart';
import 'package:naples/src/edit/properties/property.dart';

class DoubleProperty extends PropertyWidget<double?>
    with PropertyMixin<double?>
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
  final FunctionOf0<double?> getProperty;
  @override
  final ActionOf1<double?>? setProperty;
  @override
  final FunctionOf1<double?, String?>? validator;
  final bool obscureText;

  /// Inline help shown below the control when the global help toggle is on.
  final String? help;

  /// Render the value in a monospace face.
  final bool mono;

  /// Optional unit shown inside the box after the value (e.g. `€`).
  final String? unitSuffix;

  /// When set, the value is shown padded/rounded to this many decimal places
  /// (e.g. `12` → `12.00` with decimalPlaces 2).
  final int? decimalPlaces;

  DoubleProperty({
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
    this.help,
    this.mono = false,
    this.unitSuffix,
    this.decimalPlaces,
  });

  String _initialText() {
    final v = getProperty() ?? 0;
    return decimalPlaces != null ? v.toStringAsFixed(decimalPlaces!) : v.toString();
  }

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
    final t = NaplesFieldTokens.of(context);
    final roLook = !enabled;

    final field = TextFormField(
      initialValue: _initialText(),
      style: TextStyle(
        fontSize: mono ? 13.5 : 15,
        color: roLook ? t.muted : t.text,
        fontFamilyFallback: mono ? const ['JetBrains Mono', 'monospace'] : null,
        letterSpacing: mono ? -0.1 : null,
      ),
      decoration: borderlessFieldDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: t.muted, fontSize: mono ? 13.5 : 15),
        errorStyle: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12),
      ),
      enabled: true,
      readOnly: roLook,
      autofocus: autofocus,
      validator: (x) => _validator(x),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.singleLineFormatter,
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.,E\-]')),
        if (decimalPlaces != null) _DecimalPlacesInputFormatter(decimalPlaces!),
      ],
      obscureText: obscureText,
      onSaved: setProperty == null ? null : (x) => setProperty!(_getValue(x)),
    );

    return FieldScaffold(
      label: label,
      readOnly: roLook,
      help: help,
      child: FieldBox(
        readOnly: roLook,
        minHeight: FieldBox.singleLineHeight,
        center: true,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: [
            Expanded(child: field),
            if (unitSuffix != null && unitSuffix!.isNotEmpty) ...[
              const SizedBox(width: 8),
              Text(
                unitSuffix!,
                style: TextStyle(color: t.muted, fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Rejects keystrokes that would push the fractional part beyond
/// [decimalPlaces] digits (the constraint's "allowed" decimal places).
class _DecimalPlacesInputFormatter extends TextInputFormatter {
  final int decimalPlaces;
  _DecimalPlacesInputFormatter(this.decimalPlaces);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final sep = RegExp(r'[.,]').firstMatch(newValue.text);
    if (sep != null && newValue.text.length - sep.end > decimalPlaces) {
      return oldValue;
    }
    return newValue;
  }
}
