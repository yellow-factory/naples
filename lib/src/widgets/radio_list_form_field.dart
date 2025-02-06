import 'package:flutter/material.dart';
import 'package:navy/navy.dart';

class RadioListFormField<U, V> extends FormField<U> {
  RadioListFormField({
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
            void onChangedCall(U? value) {
              state.didChange(value);
              if (onChanged != null) onChanged(value);
            }

            return Column(
              children: <Widget>[
                ListTile(title: Text(label), subtitle: hint == null ? null : Text(hint)),
                for (var item in listItems())
                  RadioListTile<U>(
                    title: Text(displayMember(item)()),
                    value: valueMember(item),
                    //groupValue: property.currentValue,
                    groupValue: state.value,
                    onChanged: enabled ? onChangedCall : null, //?
                    controlAffinity: controlAffinity,
                  ),
              ],
            );
          },
        );
}
