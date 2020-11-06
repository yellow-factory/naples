import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:naples/src/edit/properties/widgets/radio_list_form_field.dart';
import 'package:naples/src/edit/properties/widgets/switch_form_field.dart';
import 'package:naples/src/edit/properties/widgets/checkbox_form_field.dart';
import 'package:naples/src/edit/properties/model_property.dart';
import 'package:naples/src/common/common.dart';
import 'package:navy/navy.dart';

enum BoolWidgetType { Switch, Checkbox, Radio }
enum BoolWidgetPosition { Leading, Trailing }
enum BoolValues { True, False }

extension BoolValuesExtension on BoolValues {
  bool get boolValue {
    if (this == BoolValues.True) return true;
    return false;
  }

  String get displayName => describeEnum(this);
}

class BoolProperty extends StatelessWidget with ModelProperty<bool>, Expandable {
  final int flex;
  final String label;
  final String hint;
  final bool autofocus;
  final PredicateOf0 editable;
  final FunctionOf0<bool> getProperty;
  final ActionOf1<bool> setProperty;
  final FunctionOf1<bool, String> validator;
  final BoolWidgetType widgetType;
  final BoolWidgetPosition widgetPosition;
  final FunctionOf1<BoolValues, FunctionOf0<String>> displayName;

  BoolProperty({
    Key key,
    this.label,
    this.hint,
    this.autofocus = false,
    this.editable,
    @required this.getProperty,
    this.setProperty,
    this.validator,
    this.flex = 1,
    this.widgetType = BoolWidgetType.Checkbox,
    this.widgetPosition = BoolWidgetPosition.Leading,
    this.displayName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controlAffinity = widgetPosition == BoolWidgetPosition.Leading
        ? ListTileControlAffinity.leading
        : ListTileControlAffinity.trailing;

    final defaultWidget = CheckboxFormField(
      autofocus: autofocus,
      enabled: editable == null ? true : editable(),
      label: label,
      hint: hint,
      initialValue: getProperty(),
      onSaved: setProperty,
      validator: validator,
      controlAffinity: controlAffinity,
    );

    switch (widgetType) {
      case BoolWidgetType.Switch:
        return SwitchFormField(
          autofocus: autofocus,
          enabled: editable == null ? true : editable(),
          label: label,
          hint: hint,
          initialValue: getProperty(),
          onSaved: setProperty,
          validator: validator,
          controlAffinity: controlAffinity,
        );
      case BoolWidgetType.Checkbox:
        return defaultWidget;
      case BoolWidgetType.Radio:
        return RadioListFormField<bool, BoolValues>(
          autofocus: autofocus,
          enabled: editable == null ? true : editable(),
          label: label,
          hint: hint,
          initialValue: getProperty(),
          onSaved: setProperty,
          validator: validator,
          controlAffinity: controlAffinity,
          listItems: () => BoolValues.values,
          valueMember: (t) => t.boolValue,
          displayMember: displayName ?? (t) => () => t.displayName,
        );
      default:
        return defaultWidget;
    }
  }
}
