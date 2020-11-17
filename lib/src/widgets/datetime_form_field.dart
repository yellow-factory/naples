import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeFormField extends FormField<DateTime> {
  DateTimeFormField({
    Key key,
    String label,
    String hint,
    DateTime initialValue,
    bool autofocus = false,
    bool enabled = true,
    FormFieldSetter<DateTime> onSaved,
    FormFieldValidator<DateTime> validator,
    DateTime firstDate,
    DateTime lastDate,
    @required DateFormat dateFormat,
    bool onlyDate = true,
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          builder: (FormFieldState<DateTime> state) {
            return TextField(
              //key: formFieldKey,
              controller: TextEditingController()
                ..text = state.value != null ? dateFormat.format(state.value) : '',
              decoration: InputDecoration(
                hintText: hint,
                labelText: label,
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today_outlined),
                  onPressed: () async {
                    final DateTime datePicked = await showDatePicker(
                          context: state.context,
                          initialDate: state.value ?? DateTime.now(),
                          firstDate: firstDate ?? DateTime(1900),
                          lastDate: lastDate ?? DateTime(2100),
                        ) ??
                        state.value;
                    if (onlyDate) {
                      if (state.value?.compareTo(datePicked) != 0) state.didChange(datePicked);
                      return null;
                    }
                    final TimeOfDay time = TimeOfDay.fromDateTime(state.value ?? DateTime.now());
                    final TimeOfDay timePicked = await showTimePicker(
                          context: state.context,
                          initialTime: time,
                        ) ??
                        time;

                    if (datePicked != null || timePicked != null) {
                      state.didChange(new DateTime(
                        datePicked != null ? datePicked.year : DateTime.now(),
                        datePicked != null ? datePicked.month : DateTime.now(),
                        datePicked != null ? datePicked.day : DateTime.now(),
                        timePicked.hour,
                        timePicked.minute,
                      ));
                    }
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
