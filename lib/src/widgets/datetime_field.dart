import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeField extends StatefulWidget {
  final String label;
  final String? hint;
  final bool filled;
  final bool autofocus;
  final bool enabled;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateFormat dateFormat;
  final bool onlyDate;
  final ValueNotifier<DateTime?> dateTimeController;

  const DateTimeField({
    super.key,
    required this.label,
    this.hint,
    this.filled = false,
    this.autofocus = false,
    this.enabled = true,
    this.firstDate,
    this.lastDate,
    required this.dateFormat,
    this.onlyDate = true,
    required this.dateTimeController,
  });

  @override
  State<DateTimeField> createState() => DateTimeFieldState();
}

class DateTimeFieldState extends State<DateTimeField> {

  late TextEditingController editingController;

  @override
  void initState() {
    super.initState();
    editingController = TextEditingController();
    widget.dateTimeController.addListener(() {
      if (widget.dateTimeController.value != null) {
        editingController.text = widget.dateFormat.format(widget.dateTimeController.value!);
      }
    });
  }

  @override
  void dispose() {
    editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var currentValue = widget.dateTimeController.value ?? DateTime.now();
    var currentFirstDate = widget.firstDate ?? DateTime(1900);
    var currentLastDate = widget.lastDate ?? DateTime(2100);

    final fieldDecoration = InputDecoration(
      hintText: widget.hint,
      labelText: widget.label,
      filled: widget.filled,
      suffixIcon: widget.enabled
          ? IconButton(
              icon: const Icon(Icons.calendar_today_outlined),
              onPressed: () async {
                final DateTime datePicked = await showDatePicker(
                      context: context,
                      initialDate: currentValue,
                      firstDate: currentFirstDate,
                      lastDate: currentLastDate,
                    ) ??
                    currentValue;

                if (widget.onlyDate) {
                  if (currentValue.compareTo(datePicked) != 0) {
                    widget.dateTimeController.value = datePicked;
                  }
                  return;
                }

                final TimeOfDay time = TimeOfDay.fromDateTime(currentValue);
                final TimeOfDay timePicked = mounted
                    ? await showTimePicker(
                          context: mounted ? context : throw Exception('Context not found'),
                          initialTime: time,
                        ) ??
                        time
                    : time;

                widget.dateTimeController.value = DateTime(
                  datePicked.year,
                  datePicked.month,
                  datePicked.day,
                  timePicked.hour,
                  timePicked.minute,
                );
              },
            )
          : null,
    );

    return TextField(
      controller: editingController
        ..text =
            widget.dateTimeController.value != null ? widget.dateFormat.format(currentValue) : '',
      decoration: fieldDecoration,
      autofocus: widget.autofocus,
      readOnly: true,
      enableInteractiveSelection: false,
    );
  }
}
