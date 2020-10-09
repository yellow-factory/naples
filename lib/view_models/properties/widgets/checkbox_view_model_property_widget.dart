import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:naples/view_models/properties/bool_property.dart';
import 'package:provider/provider.dart';

class CheckboxViewModelPropertyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final property = context.watch<BoolProperty>();
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return CheckboxListTile(
        title: Text(property.label()),
        controlAffinity: property.widgetPosition == BoolWidgetPosition.Leading
            ? ListTileControlAffinity.leading
            : ListTileControlAffinity.trailing,
        value: property.currentValue,
        onChanged: property.editable
            ? (value) {
                setState(() {
                  property.currentValue = value;
                  if (property.valid) property.update();
                });
              }
            : null,
        autofocus: property.autofocus,
        contentPadding: EdgeInsets.zero,
      );
    });
  }
}
