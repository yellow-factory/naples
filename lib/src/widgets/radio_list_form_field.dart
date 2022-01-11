import 'package:flutter/material.dart';
import 'package:navy/navy.dart';

class RadioListFormField<U, V> extends FormField<U> {
  RadioListFormField({
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
            return Column(
              children: <Widget>[
                ListTile(title: Text(label), subtitle: hint == null ? null : Text(hint)),
                for (var item in listItems())
                  RadioListTile<U>(
                    title: Text(displayMember(item)()),
                    value: valueMember(item),
                    //groupValue: property.currentValue,
                    groupValue: state.value,
                    onChanged: enabled ? state.didChange : null, //?
                    controlAffinity: controlAffinity,
                  ),
              ],
            );
          },
        );
}
