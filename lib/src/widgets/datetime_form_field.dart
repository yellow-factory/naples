import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeFormField extends FormField<DateTime> {
  DateTimeFormField({
    Key? key,
    required String label,
    String? hint,
    bool filled = false,
    DateTime? initialValue,
    bool autofocus = false,
    bool enabled = true,
    FormFieldSetter<DateTime>? onSaved,
    FormFieldValidator<DateTime>? validator,
    DateTime? firstDate,
    DateTime? lastDate,
    required DateFormat dateFormat,
    bool onlyDate = true,
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          builder: (FormFieldState<DateTime> state) {
            var currentValue = state.value ?? DateTime.now();
            var currentFirstDate = firstDate ?? DateTime(1900);
            var currentLastDate = lastDate ?? DateTime(2100);
            return TextField(
              controller: TextEditingController()
                ..text = state.value != null ? dateFormat.format(currentValue) : '',
              decoration: InputDecoration(
                hintText: hint,
                labelText: label,
                filled: filled,
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today_outlined),
                  onPressed: () async {
                    final DateTime datePicked = await showDatePicker(
                          context: state.context,
                          initialDate: currentValue,
                          firstDate: currentFirstDate,
                          lastDate: currentLastDate,
                        ) ??
                        currentValue;

                    if (onlyDate) {
                      if (currentValue.compareTo(datePicked) != 0) state.didChange(datePicked);
                      return null;
                    }

                    final TimeOfDay time = TimeOfDay.fromDateTime(currentValue);
                    final TimeOfDay timePicked = await showTimePicker(
                          context: state.context,
                          initialTime: time,
                        ) ??
                        time;

                    state.didChange(new DateTime(
                      datePicked.year,
                      datePicked.month,
                      datePicked.day,
                      timePicked.hour,
                      timePicked.minute,
                    ));
                  },
                ),
              ),
              autofocus: autofocus,
              readOnly: true,
              enableInteractiveSelection: false,
            );
          },
        );
}
