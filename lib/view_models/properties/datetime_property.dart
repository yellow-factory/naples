import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:naples/view_models/properties/widgets/datetime_view_model_property_widget.dart';
import 'package:provider/provider.dart';
import 'package:navy/navy.dart';
import 'package:naples/view_models/view_model.dart';

class DateTimeProperty extends ModelProperty<DateTime> {
  final DateFormat dateFormat;
  final bool onlyDate;
  final DateTime firstDate;
  final DateTime lastDate;

  DateTimeProperty(
    FunctionOf0<DateTime> getProperty, {
    FunctionOf0<String> label,
    FunctionOf0<String> hint,
    int flex = 1,
    bool autofocus = false,
    ActionOf1<DateTime> setProperty,
    PredicateOf0 isVisible,
    PredicateOf0 isEditable,
    FunctionOf1<DateTime, String> isValid,
    this.dateFormat,
    this.onlyDate = false,
    this.firstDate,
    this.lastDate,
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
  Widget get widget => ChangeNotifierProvider<DateTimeProperty>.value(
      value: this, child: DateTimeViewModelPropertyWidget());

  @override
  void initialize() {
    currentValue = getProperty();
  }
}
