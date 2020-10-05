import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:naples/view_models/properties/properties.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class DateTimeViewModelPropertyWidget extends StatefulWidget {
  @override
  _DateTimeViewModelPropertyWidgetState createState() => _DateTimeViewModelPropertyWidgetState();
}

class _DateTimeViewModelPropertyWidgetState extends State<DateTimeViewModelPropertyWidget> {
  TextEditingController _controller;
  DateFormat _dateFormat;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var property = context.read<DateTimeViewModelProperty>();
    if (property.dateFormat == null)
      _dateFormat = DateFormat.yMd(); 
    else
      _dateFormat = DateFormat(property.dateFormat.pattern);
    _controller.text = _setValue(property);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final property = context.watch<DateTimeViewModelProperty>();
    final formFieldKey = GlobalObjectKey(property);

    return TextFormField(
      key: formFieldKey,
      controller: _controller,
      decoration: InputDecoration(
        hintText: property.hint != null ? property.hint() : null,
        labelText: property.label != null ? property.label() : null,
        suffixIcon: IconButton(
          icon: Icon(Icons.calendar_today_outlined),
          onPressed: () async {
            var date = property.currentValue ?? DateTime.now();
            date = await _showDatePicker(
                  date,
                  property.firstDate ?? DateTime(1900),
                  property.lastDate ?? DateTime(2100),
                ) ??
                date;
            if (!property.onlyDate) date = await _showTimePicker(date) ?? date;
            property.currentValue = date;
            if (property.valid) property.update();
            _controller.text = _setValue(property);
          },
        ),
      ),
      autofocus: property.autofocus,
      readOnly: true,
      enableInteractiveSelection: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (_) => property.validate(),
    );
  }

  String _setValue(DateTimeViewModelProperty property) {
    if (property.currentValue == null) return null;
    return _dateFormat.format(property.currentValue);
  }

  Future<DateTime> _showDatePicker(DateTime date, DateTime firstDate, DateTime lastDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null && picked != date) {
      return picked;
    }
    return null;
  }

  Future<DateTime> _showTimePicker(DateTime date) async {
    final TimeOfDay time = TimeOfDay.fromDateTime(date);
    final picked = await showTimePicker(
      context: context,
      initialTime: time,
    );
    if (picked != null && picked != time) {
      return DateTime(date.year, date.month, date.day, picked.hour, picked.minute);
    }
    return null;
  }
}
