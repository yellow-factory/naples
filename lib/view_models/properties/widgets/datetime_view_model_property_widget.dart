import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naples/view_models/properties/properties.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class DateTimeViewModelPropertyWidget extends StatefulWidget {
  @override
  _DateTimeViewModelPropertyWidgetState createState() => _DateTimeViewModelPropertyWidgetState();
}

class _DateTimeViewModelPropertyWidgetState extends State<DateTimeViewModelPropertyWidget> {
  _DateTimeTextController _dateTimecontroller;

  @override
  void initState() {
    super.initState();
    final property = context.read<DateTimeViewModelProperty>();
    _dateTimecontroller =
        _DateTimeTextController(DateFormat(property.dateFormat), text: property.serializedValue);
  }

  @override
  void dispose() {
    _dateTimecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final property = context.watch<DateTimeViewModelProperty>();
    final formFieldKey = GlobalObjectKey(property);

    //TODO: Es podria millorar el inputFormatters deduïnt la llista de caràcters admesos...

    return TextFormField(
      key: formFieldKey,
      controller: _dateTimecontroller,
      decoration: InputDecoration(
        hintText: property.hint != null ? property.hint() : null,
        labelText: property.label != null ? property.label() : null,
        suffixIcon: IconButton(
          icon: Icon(Icons.calendar_today_outlined),
          onPressed: () async {
            var date = property.currentValue ?? DateTime.now();
            date = await _showDatePicker(date) ?? date;
            date = await _showTimePicker(date) ?? date;
            property.currentValue = date;
            if (property.valid) property.update();
            _dateTimecontroller.text = property.serializedValue;
            //TODO: Test cases of only date or only time..., not show dialog in all the cases...
          },
        ),
      ),
      keyboardType: TextInputType.datetime,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[0-9/: ]')),
        LengthLimitingTextInputFormatter(property.maxLength),
      ],
      autofocus: property.autofocus,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (_) => property.validate(),
      onChanged: (value) {
        if (value.length < property.dateFormat.length) return;
        var date = _tryParse(DateFormat(property.dateFormat), value);
        if (date == null) return;
        property.currentValue = date;
        if (property.valid) property.update();
      },
      obscureText: property.obscureText,
    );
  }

  DateTime _tryParse(DateFormat dateFormat, String dateTime) {
    try {
      return dateFormat.parse(dateTime);
    } catch (e) {
      return null;
    }
  }

  Future<DateTime> _showDatePicker(DateTime date) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: date,
      //locale: Locale("en"), //Cal passar-li el que toca
      firstDate: DateTime(1900), //TODO
      lastDate: DateTime(2100), //TODO
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

class _DateTimeTextController extends TextEditingController {
  final DateFormat format;
  String _lastText;
  _DateTimeTextController(this.format, {String text}) : super(text: text) {
    _lastText = text;
    selection = TextSelection.fromPosition(TextPosition(offset: _textLength));
    this.addListener(onChanged);
  }

  void onChanged() {
    if (text == null || text.isEmpty) return;
    if (_lastTextLength > _textLength) {
      _lastText = text;
      return;
    }
    var newText = _newText();
    if (newText != text) _changeText(newText);
  }

  int get _lastTextLength => (_lastText ?? '').length;
  int get _textLength => (text ?? '').length;

  void _changeText(String newText) {
    scheduleMicrotask(() {
      value = TextEditingValue(
        text: newText,
        selection: TextSelection.fromPosition(
          TextPosition(offset: newText.length),
        ),
      );
      _lastText = newText;
    });
  }

  String _newText() {
    var length = _textLength;
    var workingText = text;
    var formatPart = getFormatPart(length);

    //Only if the last digit is different than 0 tries to validate the date
    if (text.characters.last != '0') {
      if (_tryParse(formatPart, workingText) == null) return _lastText;
    }

    //Tries to increment the text with the values of the pattern if match a valid date
    while (format.pattern.length > workingText.length) {
      formatPart = getFormatPart(++length);
      var dateTime = _tryParse(formatPart, workingText);
      if (dateTime == null) break;
      var newText = formatPart.format(dateTime);
      //If the new character is digit is not what we want...
      if (format.digitMatcher.hasMatch(newText.substring(length - 1, length))) break;
      workingText = newText;
    }
    return workingText;
  }

  DateFormat getFormatPart(int length) {
    var patternPart = format.pattern.substring(0, length);
    return DateFormat(patternPart);
  }

  DateTime _tryParse(DateFormat dateFormat, String dateTime) {
    try {
      return dateFormat.parseLoose(dateTime);
    } catch (e) {
      return null;
    }
  }
}
