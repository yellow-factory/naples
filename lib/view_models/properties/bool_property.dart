import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:naples/view_models/properties/select_property.dart';
import 'package:naples/view_models/properties/widgets/radio_list_view_model_property_widget.dart';
import 'package:naples/view_models/properties/widgets/switch_view_model_property_widget.dart';
import 'package:naples/view_models/properties/widgets/checkbox_view_model_property_widget.dart';
import 'package:naples/view_models/view_model.dart';
import 'package:navy/navy.dart';
import 'package:provider/provider.dart';

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

class BoolProperty extends ModelProperty<bool> {
  BoolWidgetType widgetType = BoolWidgetType.Checkbox;
  BoolWidgetPosition widgetPosition = BoolWidgetPosition.Trailing;
  FunctionOf1<BoolValues, FunctionOf0<String>> displayName = (t) => () => t.displayName;

  BoolProperty(
    FunctionOf0<bool> getProperty, {
    FunctionOf0<String> label,
    FunctionOf0<String> hint,
    int flex,
    bool autofocus = false,
    ActionOf1<bool> setProperty,
    PredicateOf0 isVisible,
    PredicateOf0 isEditable,
    FunctionOf1<bool, String> isValid,
    this.widgetType,
    this.widgetPosition,
    this.displayName,
  }) : super(
          getProperty,
          label: label,
          hint: hint,
          flex: flex,
          autofocus: autofocus,
          setProperty: setProperty,
          isVisible: isVisible,
          isEditable: isEditable,
          isValid: isValid,
        );

  @override
  void initialize() {
    currentValue = this.getProperty() ?? false;
  }

  SelectProperty<bool, BoolValues> toSelect() {
    return SelectProperty<bool, BoolValues>(
      this.getProperty,
      () => BoolValues.values,
      (t) => t.boolValue,
      displayName,
      flex: flex,
      label: label,
      hint: hint,
      autofocus: autofocus,
      isEditable: isEditable,
      isValid: isValid,
      setProperty: setProperty,
      widgetType: SelectWidgetType.Radio,
    );
  }

  @override
  Widget get widget {
    switch (widgetType) {
      case BoolWidgetType.Switch:
        return ChangeNotifierProvider<BoolProperty>.value(
            value: this, child: SwitchViewModelPropertyWidget());
      case BoolWidgetType.Checkbox:
        return ChangeNotifierProvider<BoolProperty>.value(
            value: this, child: CheckboxViewModelPropertyWidget());
      case BoolWidgetType.Radio:
        return ChangeNotifierProvider.value(
            value: toSelect(), child: RadioListViewModelPropertyWidget<bool, BoolValues>());
      default:
        return ChangeNotifierProvider<BoolProperty>.value(
            value: this, child: CheckboxViewModelPropertyWidget());
    }
  }
}
