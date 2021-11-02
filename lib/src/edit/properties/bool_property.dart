import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:naples/src/widgets/radio_list_form_field.dart';
import 'package:naples/src/widgets/switch_form_field.dart';
import 'package:naples/src/widgets/checkbox_form_field.dart';
import 'package:naples/src/edit/properties/model_property.dart';
import 'package:naples/src/common/common.dart';
import 'package:naples/src/widgets/toggle_button_form_field.dart';
import 'package:navy/navy.dart';

enum BoolWidgetType { Switch, Checkbox, Radio, ToggleButtons }
enum BoolWidgetPosition { Leading, Trailing }
enum BoolValues { True, False }

extension BoolValuesExtension on BoolValues {
  bool get boolValue {
    if (this == BoolValues.True) return true;
    return false;
  }

  String get displayName => describeEnum(this);
}

class BoolProperty extends StatelessWidget with ModelProperty<bool?>, Expandable {
  final int flex;
  final String label;
  final String? hint;
  final bool autofocus;
  final PredicateOf0? editable;
  final FunctionOf0<bool?> getProperty;
  final ActionOf1<bool?>? setProperty;
  final FunctionOf1<bool?, String?>? validator;
  final BoolWidgetType widgetType;
  final BoolWidgetPosition widgetPosition;
  final FunctionOf1<BoolValues, FunctionOf0<String>> displayName;

  BoolProperty({
    Key? key,
    required this.label,
    this.hint,
    this.autofocus = false,
    this.editable,
    required this.getProperty,
    this.setProperty,
    this.validator,
    this.flex = 1,
    this.widgetType = BoolWidgetType.Checkbox,
    this.widgetPosition = BoolWidgetPosition.Leading,
    this.displayName = defaultDisplayName,
  }) : super(key: key);

  static FunctionOf0<String> defaultDisplayName(BoolValues t) => () => t.displayName;

  @override
  Widget build(BuildContext context) {
    final controlAffinity = widgetPosition == BoolWidgetPosition.Leading
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
    );

    switch (widgetType) {
      case BoolWidgetType.Switch:
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
      case BoolWidgetType.Checkbox:
        return defaultWidget;
      case BoolWidgetType.Radio:
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
      case BoolWidgetType.ToggleButtons:
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
      default:
        return defaultWidget;
    }
  }
}
