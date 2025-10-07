import 'package:flutter/material.dart';

class CheckboxFormField extends FormField<bool> {
  final bool showHintExplicitly;
  CheckboxFormField({
    super.key,
    required String label,
    String? hint,
    ListTileControlAffinity controlAffinity = ListTileControlAffinity.platform,
    bool initialValue = false,
    bool autofocus = false,
    bool enabled = true,
    super.onSaved,
    super.validator,
    bool saveOnValueChanged = false,
    this.showHintExplicitly = false,
  }) : super(
         initialValue: initialValue,
         builder: (FormFieldState<bool> state) {
           return CheckboxListTile(
             title: Text(label),
             subtitle: showHintExplicitly
                 ? _getSubtitle(hint, state)
                 : state.hasError
                 ? _getErrorText(state)
                 : null,
             secondary: showHintExplicitly
                 ? null
                 : Padding(
                     padding: EdgeInsets.only(right: 10),
                     child: Tooltip(message: hint ?? '', child: const Icon(Icons.info_outline)),
                   ),
             controlAffinity: controlAffinity,
             value: state.value,
             onChanged: (bool? newValue) =>
                 _onChanged(enabled, newValue, state, saveOnValueChanged),
             autofocus: autofocus,
             contentPadding: EdgeInsets.zero,
           );
         },
       );

  static void _onChanged(
    bool enabled,
    bool? newValue,
    FormFieldState<bool> state,
    bool saveOnValueChanged,
  ) {
    if (!enabled) return;
    if (state.value == newValue) return;
    state.didChange(newValue);
    if (saveOnValueChanged) state.save();
  }

  static Widget _getSubtitle(String? hint, FormFieldState<bool> state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [if (hint != null) Text(hint), if (!state.hasError) _getErrorText(state)],
    );
  }

  static Widget _getErrorText(FormFieldState<bool> state) {
    final errorColor = Theme.of(state.context).colorScheme.error;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Text(state.errorText ?? '', style: TextStyle(color: errorColor, fontSize: 12)),
    );
  }
}
