import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:navy/navy.dart';

class RadioListViewModelPropertyWidget<U, V> extends FormField<U> {
  RadioListViewModelPropertyWidget({
    Key key,
    String label,
    String hint,
    ListTileControlAffinity controlAffinity,
    U initialValue,
    bool autofocus = false,
    bool enabled = true,
    FormFieldSetter<U> onSaved,
    FormFieldValidator<U> validator,
    FunctionOf0<List<V>> listItems,
    FunctionOf1<V, U> valueMember, //Function to project U from V
    FunctionOf1<V, FunctionOf0<String>> displayMember,
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          enabled: enabled,
          builder: (FormFieldState<U> state) {
            return Column(
              children: <Widget>[
                ListTile(title: Text(label), subtitle: Text(hint)),
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

  // @override
  // Widget build(BuildContext context) {
  //   final property = context.watch<SelectProperty<U, V>>();
  //   return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
  //     return Column(
  //       key: UniqueKey(),
  //       children: <Widget>[
  //         ListTile(title: Text(property.label), subtitle: Text(property.hint())),
  //         for (var item in property.listItems())
  //           RadioListTile<U>(
  //             title: Text(property.displayMember(item)()),
  //             value: property.valueMember(item),
  //             groupValue: property.currentValue,
  //             onChanged: property.editable
  //                 ? (U value) {
  //                     setState(() {
  //                       property.currentValue = value;
  //                       if (property.validate() == null) property.update();
  //                     });
  //                   }
  //                 : null,
  //           )
  //       ],
  //     );
  //   });
  // }
}
