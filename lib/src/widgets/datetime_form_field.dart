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
            var currentValue = state.value ?? DateTime.now();
            var currentFirstDate = firstDate ?? DateTime(1900);
            var currentLastDate = lastDate ?? DateTime(2100);

            final fieldDecoration = InputDecoration(
              hintText: hint,
              labelText: label,
              errorText: state.errorText,
              filled: filled,
              suffixIcon: enabled
                  ? IconButton(
                      icon: const Icon(Icons.calendar_today_outlined),
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
                          return;
                        }

                        final TimeOfDay time = TimeOfDay.fromDateTime(currentValue);
                        final TimeOfDay timePicked = state.mounted
                            ? await showTimePicker(
                                  context: state.context,
                                  initialTime: time,
                                ) ??
                                time
                            : time;

                        state.didChange(DateTime(
                          datePicked.year,
                          datePicked.month,
                          datePicked.day,
                          timePicked.hour,
                          timePicked.minute,
                        ));
                      },
                    )
                  : null,
            );

            return TextField(
              controller: TextEditingController()
                ..text = state.value != null ? dateFormat.format(currentValue) : '',
              decoration: fieldDecoration,
              autofocus: autofocus,
              readOnly: true,
              enableInteractiveSelection: false,
            );
          },
        );
}
