import 'package:flutter/material.dart';
import 'package:naples/view_models/properties/properties.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:date_time_picker/date_time_picker.dart';

class DateTimeViewModelPropertyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final property = context.watch<DateTimeViewModelProperty>();
    final formFieldKey = GlobalObjectKey(property);

    //Not utilize DateTimePickerType.dateTimeSeparated, because causes problems

    return DateTimePicker(
      key: formFieldKey,
      type: DateTimePickerType.dateTime,
      initialValue: property.serializedValue,
      firstDate: DateTime(2000), //TODO: Implement in DateTimeViewModelProperty
      lastDate: DateTime(2100), //TODO: Implement in DateTimeViewModelProperty
      dateLabelText: property.label(),
      timeLabelText: property.label(),
      enabled: property.editable,
      autofocus: property.autofocus,
      dateMask: 'dd/MM/yyyy - hh:mm', //TODO: Implement in DateTimeViewModelProperty
      use24HourFormat: true, ////TODO: Implement in DateTimeViewModelProperty
      onChanged: (value) {
        property.serializedValue = value;
        if (property.valid) property.update();
      },
      autovalidate: true,
      validator: (_) => property.validate(),
    );
  }
}

enum PickerDemoType {
  date,
  time,
}

class PickerDemo extends StatefulWidget {
  const PickerDemo({Key key, this.type}) : super(key: key);

  final PickerDemoType type;

  @override
  _PickerDemoState createState() => _PickerDemoState();
}

class _PickerDemoState extends State<PickerDemo> {
  DateTime _fromDate = DateTime.now();
  TimeOfDay _fromTime = TimeOfDay.fromDateTime(DateTime.now());

  String get _labelText {
    switch (widget.type) {
      case PickerDemoType.date:
        return DateFormat.yMMMd().format(_fromDate);
      case PickerDemoType.time:
        return _fromTime.format(context);
    }
    return '';
  }

  Future<void> _showDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fromDate,
      firstDate: DateTime(2015, 1),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _fromDate) {
      setState(() {
        _fromDate = picked;
      });
    }
  }

  Future<void> _showTimePicker() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _fromTime,
    );
    if (picked != null && picked != _fromTime) {
      setState(() {
        _fromTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(_labelText),
        const SizedBox(height: 16),
        RaisedButton(
          child: Text(
            "Show picker",
          ),
          onPressed: () {
            switch (widget.type) {
              case PickerDemoType.date:
                _showDatePicker();
                break;
              case PickerDemoType.time:
                _showTimePicker();
                break;
            }
          },
        )
      ],
    );
  }
}
