import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yellow_naples/view_models/properties.dart';
import 'package:provider/provider.dart';

class RadioListViewModelPropertyWidget<T, U, V> extends StatelessWidget {
  //TODO: isValid is not being validated

  @override
  Widget build(BuildContext context) {
    final property = context.watch<SelectViewModelProperty<T, U, V>>();
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return Column(children: <Widget>[
        ListTile(title: Text(property.label()), subtitle: Text(property.hint())),
        for (var item in property.listItems())
          RadioListTile<U>(
            title: Text(property.displayMember(item)()),
            value: property.valueMember(item),
            groupValue: property.currentValue,
            onChanged: property.editable
                ? (U value) {
                    setState(() {
                      property.currentValue = value;
                      property.update();
                    });
                  }
                : null,
          )
      ]);
    });
  }
}
