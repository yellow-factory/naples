import 'package:flutter/material.dart';
import 'package:navy/navy.dart';

class ToggleButtonFormField<U, V> extends FormField<U> {
  ToggleButtonFormField({
    super.key,
    required String label,
    String? hint,
    ListTileControlAffinity controlAffinity = ListTileControlAffinity.platform,
    super.initialValue,
    bool autofocus = false,
    super.enabled = true,
    super.onSaved,
    super.validator,
    required FunctionOf0<List<V>> listItems,
    required FunctionOf1<V, U> valueMember, //Function to project U from V
    required FunctionOf1<V, FunctionOf0<String>> displayMember,
  }) : super(
          builder: (FormFieldState<U> state) {
            List<bool> isSelected() {
              var selectedList = <bool>[];
              for (var item in listItems()) {
                selectedList.add(valueMember(item) == state.value ? true : false);
              }
              return selectedList;
            }

            var toggleButtons = ToggleButtons(
              borderRadius: BorderRadius.circular(4.0),
              constraints: const BoxConstraints(minHeight: 36.0),
              onPressed: (index) {
                var item = listItems()[index];
                state.didChange(valueMember(item));
              },
              isSelected: isSelected(),
              children: [
                for (var item in listItems())
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(displayMember(item)()),
                  ),
              ],
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
