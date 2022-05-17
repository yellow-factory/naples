import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:naples/src/common/common.dart';
import 'package:naples/src/widgets/datetime_form_field.dart';
import 'package:navy/navy.dart';
import 'package:naples/src/edit/properties/model_property.dart';

class DateTimeProperty extends StatelessWidget with ModelProperty<DateTime?>, Expandable {
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
  final FunctionOf0<DateTime?> getProperty;
  @override
  final ActionOf1<DateTime?>? setProperty;
  @override
  final FunctionOf1<DateTime?, String?>? validator;
  final DateFormat dateFormat;
  final bool onlyDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  DateTimeProperty({
    Key? key,
    required this.getProperty,
    required this.label,
    this.hint,
    this.autofocus = false,
    this.setProperty,
    this.editable,
    this.validator,
    this.flex = 1,
    required this.dateFormat,
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
      enabled: enabled,
      initialValue: getProperty(),
      firstDate: firstDate,
      lastDate: lastDate,
      onSaved: setProperty,
      validator: validator,
      onlyDate: onlyDate,
    );
  }
}
