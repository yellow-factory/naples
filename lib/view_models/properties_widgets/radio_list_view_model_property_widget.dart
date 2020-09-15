import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yellow_naples/view_models/properties.dart';

class RadioListViewModelPropertyWidget<T, U> extends StatelessWidget {
  final SelectViewModelProperty<T, U> property;

  RadioListViewModelPropertyWidget(this.property);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return Column(children: <Widget>[
        ListTile(title: Text(property.label()), subtitle: Text(property.hint())),
        for (var item in property.listItems())
          RadioListTile<U>(
            title: Text(item.toString()),
            value: item,
            groupValue: property.currentValue,
            onChanged: property.editable
                ? (U value) {
                    setState(() {
                      property.currentValue = value;
                    });
                  }
                : null,
          )
      ]);
    });
  }
}
