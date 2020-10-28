import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CheckboxViewModelPropertyWidget extends FormField<bool> {
  CheckboxViewModelPropertyWidget({
    Key key,
    @required String label,
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
            return CheckboxListTile(
              title: Text(label),
              subtitle: hint == null ? null : Text(hint),
              controlAffinity: controlAffinity,
              value: state.value,
              onChanged: enabled ? state.didChange : null, //?
              autofocus: autofocus,
              contentPadding: EdgeInsets.zero,
            );
          },
        );

  // @override
  // Widget build(BuildContext context) {
  //   final property = context.watch<BoolProperty>();
  //   return StatefulBuilder(builder: (
  //     BuildContext context,
  //     StateSetter setState,
  //   ) {
  //     return CheckboxListTile(
  //       title: Text(property.label),
  //       controlAffinity: property.widgetPosition == BoolWidgetPosition.Leading
  //           ? ListTileControlAffinity.leading
  //           : ListTileControlAffinity.trailing,
  //       value: property.currentValue,
  //       onChanged: property.editable
  //           ? (value) {
  //               setState(() {
  //                 property.currentValue = value;
  //                 if (property.validate() == null) property.update();
  //               });
  //             }
  //           : null,
  //       autofocus: property.autofocus,
  //       contentPadding: EdgeInsets.zero,
  //     );
  //   });
  // }
}
