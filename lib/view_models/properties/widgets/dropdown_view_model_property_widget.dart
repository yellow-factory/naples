import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:naples/view_models/properties/properties.dart';
import 'package:provider/provider.dart';

class DropDownViewModelPropertyWidget<T, U, V> extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final property = context.watch<SelectViewModelProperty<T, U, V>>();
    var items = <DropdownMenuItem<U>>[
      for (var item in property.listItems())
        DropdownMenuItem<U>(
          value: property.valueMember(item),
          child: Text(property.displayMember(item)()),
        )
    ];
    return DropdownButtonFormField<U>(
      key: UniqueKey(),
      items: items,
      value: property.currentValue,
      onChanged: (value) {
        property.currentValue = value;
        property.update();
      },
    );
  }
}
