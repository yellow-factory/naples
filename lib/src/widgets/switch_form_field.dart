import 'package:flutter/material.dart';

class SwitchFormField extends FormField<bool> {
  SwitchFormField({
    super.key,
    required String label,
    String? hint,
    ListTileControlAffinity controlAffinity = ListTileControlAffinity.platform,
    bool initialValue = false,
    bool autofocus = false,
    bool enabled = true,
    super.onSaved,
    super.validator,
  }) : super(
          initialValue: initialValue,
          builder: (FormFieldState<bool> state) {
            return SwitchListTile(
                title: Text(label),
                subtitle: _getSubtitle(hint, state),
                controlAffinity: controlAffinity,
                value: state.value ?? false,
                onChanged: enabled ? state.didChange : null,
                autofocus: autofocus,
                contentPadding: EdgeInsets.zero
                // activeTrackColor: Colors.lightGreenAccent,
                // activeColor: Colors.green,
                );
          },
        );

  static Widget _getSubtitle(String? hint, FormFieldState<bool> state) {
    final errorColor = Theme.of(state.context).colorScheme.error;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hint != null) Text(hint),
        if (state.hasError)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
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
