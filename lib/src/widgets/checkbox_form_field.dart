import 'package:flutter/material.dart';

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
              subtitle: _getSubtitle(hint, state),
              controlAffinity: controlAffinity,
              value: state.value,
              onChanged: enabled ? state.didChange : null, //?
              autofocus: autofocus,
              contentPadding: EdgeInsets.zero,
            );
          },
        );

  static Widget _getSubtitle(String? hint, FormFieldState<bool> state) {
    final errorColor = Theme.of(state.context).errorColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hint != null) Text(hint),
        if (state.hasError)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: Text(
              state.errorText ?? '',
              style: TextStyle(
                color: errorColor,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
