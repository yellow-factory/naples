import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:naples/src/view_models/edit/properties/widgets/datetime_widget.dart';
import 'package:navy/navy.dart';
import 'package:naples/src/view_models/edit/properties/model_property.dart';

class DateTimeProperty extends ModelProperty<DateTime> {
  final DateFormat dateFormat;
  final bool onlyDate;
  final DateTime firstDate;
  final DateTime lastDate;

  DateTimeProperty({
    Key key,
    @required FunctionOf0<DateTime> getProperty,
    String label,
    String hint,
    int flex = 1,
    bool autofocus = false,
    ActionOf1<DateTime> setProperty,
    PredicateOf0 isEditable,
    FunctionOf1<DateTime, String> isValid,
    @required this.dateFormat,
    this.onlyDate = false,
    this.firstDate,
    this.lastDate,
  }) : super(
          key: key,
          getProperty: getProperty,
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
    return DateTimeViewModelPropertyWidget(
      label: label,
      hint: hint,
      autofocus: autofocus,
      dateFormat: dateFormat,
      enabled: isEditable == null ? true : isEditable(),
      initialValue: getProperty(),
      firstDate: firstDate,
      lastDate: lastDate,
      onSaved: setProperty,
      validator: isValid,
      onlyDate: onlyDate,
    );
  }
}
