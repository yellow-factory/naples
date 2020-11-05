import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SwitchViewModelPropertyWidget extends FormField<bool> {
  SwitchViewModelPropertyWidget({
    Key key,
    String label,
    String hint,
    ListTileControlAffinity controlAffinity,
    bool initialValue = false,
    bool autofocus = false,
    bool enabled = true,
    FormFieldSetter<bool> onSaved,
    FormFieldValidator<bool> validator,
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          builder: (FormFieldState<bool> state) {
            return SwitchListTile(
                title: Text(label),
                subtitle: Text(hint),
                controlAffinity: controlAffinity,
                value: state.value,
                onChanged: enabled ? state.didChange : null,
                autofocus: autofocus,
                contentPadding: EdgeInsets.zero
                // activeTrackColor: Colors.lightGreenAccent,
                // activeColor: Colors.green,
                );
          },
        );
}
