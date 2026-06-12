import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naples/src/common/common.dart';
import 'package:naples/src/widgets/boxed_text_form_field.dart';
import 'package:naples/src/widgets/field_box.dart';
import 'package:navy/navy.dart';
import 'package:naples/src/edit/properties/property.dart';
import 'package:clipboard/clipboard.dart';

class StringProperty extends PropertyWidget<String?>
    with PropertyMixin<String?>
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
  final FunctionOf0<String?> getProperty;
  @override
  final ActionOf1<String?>? setProperty;
  @override
  final FunctionOf1<String?, String?>? validator;
  final bool obscureText;
  final int maxLength;
  final bool showCopyButton;
  final bool readOnly;
  final int minLines;
  final int maxLines;
  final VoidCallback? onEditPressed;

  /// Inline help/description shown below the control when an ancestor
  /// [FieldHelpScope] is visible (driven by the host's global "Help" toggle).
  final String? help;

  /// Placeholder shown when the field is empty (e.g. an empty textarea).
  final String? placeholder;

  /// Render the value in a monospace face (UUIDs, codes, technical values).
  final bool mono;

  /// Optional unit shown inside the box after the value (e.g. `€`).
  final String? unitSuffix;

  /// Optional callback invoked on every text change (i.e. on each
  /// keystroke). Use sparingly — most callers should rely on `setProperty`
  /// at form-save time. Needed when the field's surrounding affordances
  /// must react to the current text without waiting for the host form to
  /// save (e.g. a per-field button whose enabled state depends on the
  /// value being non-empty).
  final ValueChanged<String>? onChanged;

  /// Optional callback that, when non-null, surfaces a translate icon inside
  /// the field's suffix slot — same row as `onEditPressed`/copy. Used by
  /// upstream apps to attach a per-field translations dialog without
  /// breaking the field's underline (a wrapper widget would split it).
  final VoidCallback? onTranslatePressed;

  /// Whether the translate icon should be interactive. When false the
  /// icon still renders (so users see the affordance is *available* for
  /// this field) but is greyed out and ignores taps — typically used by
  /// callers to gate translation editing behind a precondition such as
  /// "the source-language value must be entered first". The supplied
  /// [translateTooltip] should explain the gate.
  final bool translateEnabled;

  /// Optional tooltip shown on the translate icon.
  final String? translateTooltip;

  /// Forwarded to the underlying [FormField] so callers can opt into live
  /// validation (e.g. per-keystroke) instead of validate-on-save.
  final AutovalidateMode? autovalidateMode;

  StringProperty({
    super.key,
    required this.label,
    this.hint,
    this.autofocus = false,
    required this.getProperty,
    this.setProperty,
    this.editable,
    this.validator,
    this.flex = 1,
    this.obscureText = false,
    this.maxLength = -1,
    this.showCopyButton = false,
    this.readOnly = false,
    this.minLines = 1,
    this.maxLines = 1,
    this.onEditPressed,
    this.help,
    this.placeholder,
    this.mono = false,
    this.unitSuffix,
    this.onChanged,
    this.onTranslatePressed,
    this.translateEnabled = true,
    this.translateTooltip,
    this.autovalidateMode,
  });

  List<Widget> _buildActions() {
    return [
      if (showCopyButton)
        FieldActionButton(
          icon: Icons.copy,
          onPressed: () => FlutterClipboard.copy(getProperty() ?? ''),
        ),
      if (onEditPressed != null) FieldActionButton(icon: Icons.edit, onPressed: onEditPressed),
      if (onTranslatePressed != null)
        FieldActionButton(
          icon: Icons.translate,
          tooltip: translateTooltip,
          onPressed: translateEnabled ? onTranslatePressed : null,
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // "Read-only look" = dashed/transparent box + lock icon. Applies when the
    // field isn't editable (computed/virtual/parent-readonly) or when the
    // caller forced read-only (e.g. an editwidget-backed field).
    final roLook = !enabled || readOnly;

    return BoxedTextFormField(
      label: label,
      help: help,
      // `placeholder` is the handoff empty-state text; fall back to `hint`
      // so existing callers that pass a hint keep their placeholder.
      hintText: placeholder ?? hint,
      readOnlyLook: roLook,
      autofocus: autofocus,
      obscureText: obscureText,
      mono: mono,
      unitSuffix: unitSuffix,
      minLines: minLines,
      maxLines: maxLines,
      inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
      onChanged: onChanged,
      actions: _buildActions(),
      initialValue: getProperty(),
      validator: validator,
      onSaved: setProperty,
      autovalidateMode: autovalidateMode,
    );
  }
}
