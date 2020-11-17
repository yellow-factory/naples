import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:naples/src/common/common.dart';
import 'package:naples/src/widgets/datetime_form_field.dart';
import 'package:navy/navy.dart';
import 'package:naples/src/edit/properties/model_property.dart';

class DateTimeProperty extends StatelessWidget with ModelProperty<DateTime>, Expandable {
  final int flex;
  final String label;
  final String hint;
  final bool autofocus;
  final PredicateOf0 editable;
  final FunctionOf0<DateTime> getProperty;
  final ActionOf1<DateTime> setProperty;
  final FunctionOf1<DateTime, String> validator;
  final DateFormat dateFormat;
  final bool onlyDate;
  final DateTime firstDate;
  final DateTime lastDate;

  DateTimeProperty({
    Key key,
    @required this.getProperty,
    this.label,
    this.hint,
    this.autofocus = false,
    this.setProperty,
    this.editable,
    this.validator,
    this.flex = 1,
    @required this.dateFormat,
    this.onlyDate = false,
    this.firstDate,
    this.lastDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DateTimeFormField(
      label: label,
      hint: hint,
      autofocus: autofocus,
      dateFormat: dateFormat,
      enabled: editable == null ? true : editable(),
      initialValue: getProperty(),
      firstDate: firstDate,
      lastDate: lastDate,
      onSaved: setProperty,
      validator: validator,
      onlyDate: onlyDate,
    );
  }
}
