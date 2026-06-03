import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naples/src/common/common.dart';
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
    this.onChanged,
    this.onTranslatePressed,
    this.translateEnabled = true,
    this.translateTooltip,
  });

  Widget? _buildSuffixIcon() {
    final List<Widget> icons = [];
    if (showCopyButton) {
      icons.add(IconButton(
        icon: const Icon(Icons.copy),
        onPressed: () => FlutterClipboard.copy(getProperty() ?? ''),
      ));
    }
    if (onEditPressed != null) {
      icons.add(IconButton(
        icon: const Icon(Icons.edit),
        onPressed: onEditPressed,
      ));
    }
    if (onTranslatePressed != null) {
      icons.add(IconButton(
        tooltip: translateTooltip,
        icon: const Icon(Icons.translate),
        // null onPressed → Material renders the IconButton greyed out and
        // makes it non-interactive. We keep the IconButton in the row (vs
        // hiding it) so the user still sees the affordance is supported
        // for this field; the tooltip is expected to explain the gate.
        onPressed: translateEnabled ? onTranslatePressed : null,
      ));
    }
    if (icons.isEmpty) return null;
    if (icons.length == 1) return icons.first;
    return Row(mainAxisSize: MainAxisSize.min, children: icons);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: getProperty(),
      decoration: InputDecoration(
        //filled: true,
        hintText: hint,
        labelText: label,
        suffixIcon: _buildSuffixIcon(),
      ),
      enabled: enabled,
      autofocus: autofocus,
      validator: validator,
      obscureText: obscureText,
      //maxLength: property.maxLength,
      inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
      minLines: minLines,
      maxLines: maxLines,
      onChanged: onChanged,
      onSaved: setProperty,
      readOnly: readOnly,
    );
  }
}

//TODO: Potser seria millor que fos un stateful widget que implementés validable
//i que no fés el save fins que és vàlid, així evitaríem per exmple que es mostressin
//a l'informe valors incoherents. Es podria mirar el onchanged i fer que es validés el
//resultat cada cop que onchanged, i si el resultat és vàlid que es fes el save
//Ara tal com està actuant: qualsevol canvi que hi hagi al form provoca el setProperty
//a través del onSaved
//Això permetria que el Validable de DynamicForm tingués en compte el Validable dels de més avall
