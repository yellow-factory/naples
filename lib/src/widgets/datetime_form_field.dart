import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeFormField extends FormField<DateTime> {
  DateTimeFormField({
    super.key,
    required String label,
    String? hint,
    bool filled = false,
    super.initialValue,
    bool autofocus = false,
    bool enabled = true,
    super.onSaved,
    super.validator,
    DateTime? firstDate,
    DateTime? lastDate,
    required DateFormat dateFormat,
    bool onlyDate = true,
  }) : super(
         builder: (FormFieldState<DateTime> state) {
           return _DateTimeFormFieldContent(
             state: state,
             label: label,
             hint: hint,
             filled: filled,
             autofocus: autofocus,
             enabled: enabled,
             firstDate: firstDate,
             lastDate: lastDate,
             dateFormat: dateFormat,
             onlyDate: onlyDate,
           );
         },
       );
}

class _DateTimeFormFieldContent extends StatefulWidget {
  final FormFieldState<DateTime> state;
  final String label;
  final String? hint;
  final bool filled;
  final bool autofocus;
  final bool enabled;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateFormat dateFormat;
  final bool onlyDate;

  const _DateTimeFormFieldContent({
    required this.state,
    required this.label,
    this.hint,
    required this.filled,
    required this.autofocus,
    required this.enabled,
    this.firstDate,
    this.lastDate,
    required this.dateFormat,
    required this.onlyDate,
  });

  @override
  State<_DateTimeFormFieldContent> createState() => _DateTimeFormFieldContentState();
}

class _DateTimeFormFieldContentState extends State<_DateTimeFormFieldContent> {
  late TextEditingController _controller;
  DateTime? _lastValue;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _lastValue = widget.state.value;
    _syncText();
  }

  @override
  void didUpdateWidget(_DateTimeFormFieldContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_lastValue != widget.state.value) {
      _lastValue = widget.state.value;
      _syncText();
    }
  }

  void _syncText() {
    final value = widget.state.value;
    _controller.text = value != null ? widget.dateFormat.format(value.toLocal()) : '';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var currentValue = widget.state.value?.toLocal() ?? DateTime.now();
    var currentFirstDate = widget.firstDate ?? DateTime(1900);
    var currentLastDate = widget.lastDate ?? DateTime(2100);

    final fieldDecoration = InputDecoration(
      hintText: widget.hint,
      labelText: widget.label,
      errorText: widget.state.errorText,
      filled: widget.filled,
      enabled: widget.enabled,
      suffixIcon: widget.enabled
          ? IconButton(
              icon: const Icon(Icons.calendar_today_outlined),
              onPressed: () async {
                final DateTime datePicked =
                    await showDatePicker(
                      context: context,
                      initialDate: currentValue,
                      firstDate: currentFirstDate,
                      lastDate: currentLastDate,
                      fieldLabelText: widget.label,
                      fieldHintText: widget.hint,
                    ) ??
                    currentValue;

                if (widget.onlyDate) {
                  if (currentValue.compareTo(datePicked) != 0) {
                    widget.state.didChange(datePicked);
                  }
                  return;
                }

                final TimeOfDay time = TimeOfDay.fromDateTime(currentValue);
                final TimeOfDay timePicked = mounted
                    ? await showTimePicker(
                            context: mounted ? context : throw Exception('Not mounted'),
                            initialTime: time,
                            initialEntryMode: TimePickerEntryMode.input,
                          ) ??
                          time
                    : time;

                if (!mounted) return;

                widget.state.didChange(
                  DateTime(
                    datePicked.year,
                    datePicked.month,
                    datePicked.day,
                    timePicked.hour,
                    timePicked.minute,
                  ),
                );
              },
            )
          : null,
    );

    return TextField(
      controller: _controller,
      decoration: fieldDecoration,
      autofocus: widget.autofocus,
      readOnly: true,
      enableInteractiveSelection: false,
    );
  }
}
