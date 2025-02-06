import 'package:flutter/material.dart';
import 'package:naples/dialogs.dart';
import 'package:navy/navy.dart';

class SelectDialogFormField<U, V> extends FormField<U> {
  SelectDialogFormField({
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
    Function(U?)? onChanged,
  }) : super(
          builder: (FormFieldState<U> state) {
            final items = listItems();
            final valueV = state.value == null ||
                    items.isEmpty ||
                    !items.any((element) => valueMember(element) == state.value)
                ? null
                : items.firstWhere((element) => valueMember(element) == state.value);
            final initialValueDisplayed = valueV == null ? null : displayMember(valueV);
            final title = initialValueDisplayed == null ? null : initialValueDisplayed();

            return TextField(
              controller: TextEditingController(text: title),
              decoration: InputDecoration(
                hintText: hint,
                labelText: label,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: enabled
                      ? () async {
                          final result = await showSelectDialog<V>(
                              title: label,
                              subtitle: hint,
                              context: state.context,
                              items: items,
                              selectedItem: valueV,
                              displayMember: (t) => displayMember(t)());
                          if (result == null) return;
                          var value = valueMember(result);
                          state.didChange(value);
                          if (onChanged != null) onChanged(value);
                        }
                      : null,
                ),
              ),
              readOnly: true,
            );
          },
        );
}
