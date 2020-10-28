import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:naples/src/view_models/edit/properties/widgets/radio_list_widget.dart';
import 'package:naples/src/view_models/edit/properties/widgets/switch_widget.dart';
import 'package:naples/src/view_models/edit/properties/widgets/checkbox_widget.dart';
import 'package:naples/src/view_models/edit/properties/model_property.dart';
import 'package:naples/widgets/expandable.dart';
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

class BoolProperty extends ModelProperty<bool> implements Expandable {
  final BoolWidgetType widgetType;
  final BoolWidgetPosition widgetPosition;
  final FunctionOf1<BoolValues, FunctionOf0<String>> displayName;

  BoolProperty({
    @required FunctionOf0<bool> getProperty,
    String label,
    String hint,
    int flex,
    bool autofocus = false,
    ActionOf1<bool> setProperty,
    PredicateOf0 isEditable,
    FunctionOf1<bool, String> isValid,
    this.widgetType = BoolWidgetType.Checkbox,
    this.widgetPosition = BoolWidgetPosition.Leading,
    this.displayName,
  }) : super(
          getProperty: getProperty ?? false,
          label: label,
          hint: hint,
          flex: flex,
          autofocus: autofocus,
          setProperty: setProperty,
          isEditable: isEditable,
          isValid: isValid,
        );

  @override
  Widget build(BuildContext context) {
    final controlAffinity = widgetPosition == BoolWidgetPosition.Leading
        ? ListTileControlAffinity.leading
        : ListTileControlAffinity.trailing;

    final defaultWidget = CheckboxViewModelPropertyWidget(
      autofocus: autofocus,
      enabled: isEditable == null ? true : isEditable(),
      label: label,
      hint: hint,
      initialValue: getProperty(),
      onSaved: setProperty,
      validator: isValid,
      controlAffinity: controlAffinity,
    );

    switch (widgetType) {
      case BoolWidgetType.Switch:
        return SwitchViewModelPropertyWidget(
          autofocus: autofocus,
          enabled: isEditable == null ? true : isEditable(),
          label: label,
          hint: hint,
          initialValue: getProperty(),
          onSaved: setProperty,
          validator: isValid,
          controlAffinity: controlAffinity,
        );
      case BoolWidgetType.Checkbox:
        return defaultWidget;
      case BoolWidgetType.Radio:
        return RadioListViewModelPropertyWidget<bool, BoolValues>(
          autofocus: autofocus,
          enabled: isEditable == null ? true : isEditable(),
          label: label,
          hint: hint,
          initialValue: getProperty(),
          onSaved: setProperty,
          validator: isValid,
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
