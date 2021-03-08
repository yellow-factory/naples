import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CheckboxFormField extends FormField<bool> {
  CheckboxFormField({
    Key? key,
    required String label,
    String? hint,
    ListTileControlAffinity controlAffinity = ListTileControlAffinity.platform,
    bool initialValue = false,
    bool autofocus = false,
    bool enabled = true,
    FormFieldSetter<bool>? onSaved,
    FormFieldValidator<bool>? validator,
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          builder: (FormFieldState<bool> state) {
            return CheckboxListTile(
              title: Text(label),
              subtitle: hint == null ? null : Text(hint),
              controlAffinity: controlAffinity,
              value: state.value,
              onChanged: enabled ? state.didChange : null, //?
              autofocus: autofocus,
              contentPadding: EdgeInsets.zero,
            );
          },
        );
}
