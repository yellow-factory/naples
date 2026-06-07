import 'package:flutter/material.dart';
import 'package:naples/src/widgets/radio_list_form_field.dart';
import 'package:naples/src/widgets/switch_box_form_field.dart';
import 'package:naples/src/widgets/checkbox_form_field.dart';
import 'package:naples/src/widgets/field_scaffold.dart';
import 'package:naples/src/edit/properties/property.dart';
import 'package:naples/src/common/common.dart';
import 'package:naples/src/widgets/toggle_button_form_field.dart';
import 'package:navy/navy.dart';

enum BoolWidgetType { switchBox, checkBox, radioButton, toggleButton }

enum BoolWidgetPosition { leading, trailing }

enum BoolValues { isTrue, isFalse }

extension BoolValuesExtension on BoolValues {
  bool get boolValue {
    if (this == BoolValues.isTrue) return true;
    return false;
  }

  String get displayName => name;
}

class BoolProperty extends PropertyWidget<bool?> with PropertyMixin<bool?> implements Expandable {
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
  final FunctionOf0<bool?> getProperty;
  @override
  final ActionOf1<bool?>? setProperty;
  @override
  final FunctionOf1<bool?, String?>? validator;
  final BoolWidgetType widgetType;
  final BoolWidgetPosition widgetPosition;
  final FunctionOf1<BoolValues, FunctionOf0<String>> displayName;
  //Calls setProperty on control value change
  final bool saveOnValueChanged;
  final bool showHintExplicitly;

  /// Inline help shown under the label in the boxed switch (falls back to
  /// [hint]); only visible when an ancestor `FieldHelpScope` is on.
  final String? help;

  /// The boxed variants ([BoolWidgetType.switchBox]/[BoolWidgetType.checkBox])
  /// carry their label *inside* the box, so on their own they have no external
  /// label line. When placed next to labelled fields (which render a label above
  /// their box), this leaves the boolean's box riding up against the neighbour's
  /// label. Set this true to reserve an empty external-label slot — matching the
  /// labelled fields' anatomy — so the box lines up with theirs. Leave false for
  /// standalone booleans (settings lists, dialogs) where the extra top gap is
  /// unwanted.
  final bool reserveLabelSpace;

  BoolProperty({
    super.key,
    required this.label,
    this.hint,
    this.autofocus = false,
    this.editable,
    required this.getProperty,
    this.setProperty,
    this.validator,
    this.flex = 1,
    this.widgetType = BoolWidgetType.checkBox,
    this.widgetPosition = BoolWidgetPosition.leading,
    this.displayName = defaultDisplayName,
    this.saveOnValueChanged = false,
    this.showHintExplicitly = false,
    this.help,
    this.reserveLabelSpace = false,
  });

  static FunctionOf0<String> defaultDisplayName(BoolValues t) =>
      t == BoolValues.isTrue ? () => 'Yes' : () => 'No';

  @override
  Widget build(BuildContext context) {
    final controlAffinity =
        widgetPosition == BoolWidgetPosition.leading
            ? ListTileControlAffinity.leading
            : ListTileControlAffinity.trailing;

    final defaultWidget = CheckboxFormField(
      autofocus: autofocus,
      enabled: enabled,
      label: label,
      hint: hint,
      initialValue: getProperty() ?? false,
      onSaved: setProperty,
      validator: validator,
      controlAffinity: controlAffinity,
      saveOnValueChanged: saveOnValueChanged,
      // When reserving a label slot the help is rendered below the box by the
      // wrapping FieldScaffold (like other fields), so don't repeat it inside.
      showHintExplicitly: reserveLabelSpace ? false : showHintExplicitly,
    );

    //TODO: He implementat el saveOnValueChanged a CheckboxFormField, però no a SwitchFormField, ToggleButtonFormField, RadioListFormField
    //però també cal fer el mateix amb els altres widgets

    //TODO: He implementat el showHintExplicitly a CheckboxFormField, però no a SwitchFormField, ToggleButtonFormField, RadioListFormField
    //però també cal fer el mateix amb els altres widgets

    final Widget control = switch (widgetType) {
      BoolWidgetType.switchBox => SwitchBoxFormField(
          enabled: enabled,
          label: label,
          // When reserving a label slot the help is rendered below the box by the
          // wrapping FieldScaffold (like other fields), so don't repeat it inside.
          help: reserveLabelSpace ? null : (help ?? hint),
          initialValue: getProperty() ?? false,
          onSaved: setProperty,
          validator: validator,
          saveOnValueChanged: saveOnValueChanged,
          onImmediateChange: setProperty,
        ),
      BoolWidgetType.checkBox => defaultWidget,
      BoolWidgetType.radioButton => RadioListFormField<bool, BoolValues>(
          autofocus: autofocus,
          enabled: enabled,
          label: label,
          hint: hint,
          initialValue: getProperty(),
          onSaved: setProperty,
          validator: validator,
          controlAffinity: controlAffinity,
          listItems: () => BoolValues.values,
          valueMember: (t) => t.boolValue,
          displayMember: displayName,
        ),
      BoolWidgetType.toggleButton => ToggleButtonFormField<bool, BoolValues>(
          autofocus: autofocus,
          enabled: enabled,
          label: label,
          hint: hint,
          initialValue: getProperty(),
          onSaved: setProperty,
          validator: validator,
          controlAffinity: controlAffinity,
          listItems: () => BoolValues.values,
          valueMember: (t) => t.boolValue,
          displayMember: displayName,
        ),
    };

    // Reserve an empty external-label line so the boxed control lines up with
    // labelled fields beside it, and render the help below the box (outside the
    // grey area) the same way FieldScaffold does for every other field type.
    if (reserveLabelSpace) {
      return FieldScaffold(label: '', help: help ?? hint, child: control);
    }
    return control;
  }
}
