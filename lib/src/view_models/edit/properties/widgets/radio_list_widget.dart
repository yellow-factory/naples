import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:naples/src/view_models/edit/properties/select_property.dart';
import 'package:provider/provider.dart';

class RadioListViewModelPropertyWidget<U, V> extends StatelessWidget {
  //TODO: isValid is not being validated

  @override
  Widget build(BuildContext context) {
    final property = context.watch<SelectProperty<U, V>>();
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return Column(
        key: UniqueKey(),
        children: <Widget>[
          ListTile(title: Text(property.label(context)), subtitle: Text(property.hint(context))),
          for (var item in property.listItems())
            RadioListTile<U>(
              title: Text(property.displayMember(item)()),
              value: property.valueMember(item),
              groupValue: property.currentValue,
              onChanged: property.editable
                  ? (U value) {
                      setState(() {
                        property.currentValue = value;
                        if (property.validate(context) == null) property.update(context);
                      });
                    }
                  : null,
            )
        ],
      );
    });
  }
}
