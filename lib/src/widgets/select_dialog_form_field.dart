import 'package:flutter/material.dart';
import 'package:naples/dialogs.dart';
import 'package:navy/navy.dart';

class SelectDialogFormField<U, V> extends FormField<U> {
  SelectDialogFormField({
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
    Function(U?)? onChanged,
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          enabled: enabled,
          builder: (FormFieldState<U> state) {
            void onChangedCall(U? value) {
              state.didChange(value);
              if (onChanged != null) onChanged(value);
            }

            final items = listItems();
            final projectedItems = items.map(valueMember).toList();
            final valueV = state.value == null ||
                    items.isEmpty ||
                    !items.any((element) => valueMember(element) == state.value)
                ? null
                : items.firstWhere((element) => valueMember(element) == state.value);
            final initialValueDisplayed = valueV == null ? null : displayMember(valueV);

            final title = initialValueDisplayed == null ? label : initialValueDisplayed();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (state.value != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 0, bottom: 5),
                              child: Text(
                                label,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                          Text(
                            title,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: enabled
                          ? () async {
                              final result = await showSelectDialog<U>(
                                title: label,
                                subtitle: hint,
                                context: state.context,
                                items: projectedItems,
                              );
                              if (result != null) {
                                onChangedCall(result);
                              }
                            }
                          : null,
                    )
                  ],
                ),
                const Divider(
                  height: 10,
                  thickness: 1,
                ),
              ],
            );
          },
        );
}
