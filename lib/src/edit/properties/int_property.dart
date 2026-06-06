import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naples/src/common/common.dart';
import 'package:naples/src/common/field_tokens.dart';
import 'package:naples/src/widgets/field_box.dart';
import 'package:naples/src/widgets/field_scaffold.dart';
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
    final t = NaplesFieldTokens.of(context);
    final roLook = !enabled;

    final field = TextFormField(
      initialValue: (getProperty() ?? 0).toString(),
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
      validator: validator == null ? null : (x) => validator!(_getValue(x)),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(maxLength),
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
