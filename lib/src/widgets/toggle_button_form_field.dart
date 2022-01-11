import 'package:flutter/material.dart';
import 'package:navy/navy.dart';

class ToggleButtonFormField<U, V> extends FormField<U> {
  ToggleButtonFormField({
    Key? key,
    required String label,
    String? hint,
    ListTileControlAffinity controlAffinity = ListTileControlAffinity.platform,
    U? initialValue,
    bool autofocus = false,
    bool enabled = true,
    FormFieldSetter<U>? onSaved,
    FormFieldValidator<U>? validator,
    required FunctionOf0<List<V>> listItems,
    required FunctionOf1<V, U> valueMember, //Function to project U from V
    required FunctionOf1<V, FunctionOf0<String>> displayMember,
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          enabled: enabled,
          builder: (FormFieldState<U> state) {
            List<bool> isSelected() {
              var selectedList = <bool>[];
              for (var item in listItems())
                selectedList.add(valueMember(item) == state.value ? true : false);
              return selectedList;
            }

            var toggleButtons = ToggleButtons(
              borderRadius: BorderRadius.circular(4.0),
              constraints: BoxConstraints(minHeight: 36.0),
              onPressed: (index) {
                var item = listItems()[index];
                state.didChange(valueMember(item));
              },
              children: [
                for (var item in listItems())
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(displayMember(item)()),
                  ),
              ],
              isSelected: isSelected(),
            );

            return ListTile(
              title: Text(label),
              leading: controlAffinity == ListTileControlAffinity.leading ? toggleButtons : null,
              trailing: controlAffinity != ListTileControlAffinity.leading ? toggleButtons : null,
              subtitle: _getSubtitle(hint, state),
              contentPadding: EdgeInsets.zero,
            );
          },
        );

  static Widget _getSubtitle(String? hint, FormFieldState state) {
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
