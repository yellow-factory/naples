import 'package:flutter/material.dart';
import 'package:naples/src/widgets/radio_list_form_field.dart';
import 'package:naples/src/widgets/switch_form_field.dart';
import 'package:naples/src/widgets/checkbox_form_field.dart';
import 'package:naples/src/edit/properties/model_property.dart';
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

class BoolProperty extends ModelPropertyWidget<bool?>
    with ModelPropertyMixin<bool?>
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
  });

  static FunctionOf0<String> defaultDisplayName(BoolValues t) => () => t.displayName;

  @override
  Widget build(BuildContext context) {
    final controlAffinity = widgetPosition == BoolWidgetPosition.leading
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
    );

//TODO: He implementat el saveOnValueChanged a CheckboxFormField, però no a SwitchFormField, ToggleButtonFormField, RadioListFormField
//però també cal fer el mateix amb els altres widgets

    switch (widgetType) {
      case BoolWidgetType.switchBox:
        return SwitchFormField(
          autofocus: autofocus,
          enabled: enabled,
          label: label,
          hint: hint,
          initialValue: getProperty() ?? false,
          onSaved: setProperty,
          validator: validator,
          controlAffinity: controlAffinity,
        );
      case BoolWidgetType.checkBox:
        return defaultWidget;
      case BoolWidgetType.radioButton:
        return RadioListFormField<bool, BoolValues>(
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
        );
      case BoolWidgetType.toggleButton:
        return ToggleButtonFormField<bool, BoolValues>(
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
        );
    }
  }
}
