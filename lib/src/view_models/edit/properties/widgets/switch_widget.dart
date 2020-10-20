import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naples/src/view_models/edit/properties/bool_property.dart';
import 'package:provider/provider.dart';

class SwitchViewModelPropertyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final property = context.watch<BoolProperty>();
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return SwitchListTile(
          key: UniqueKey(),
          title: Text(property.label()),
          controlAffinity: property.widgetPosition == BoolWidgetPosition.Leading
              ? ListTileControlAffinity.leading
              : ListTileControlAffinity.trailing,
          value: property.currentValue,
          onChanged: property.editable
              ? (value) {
                  setState(() {
                    property.currentValue = value;
                    if (property.validate() == null) property.update();
                  });
                }
              : null,
          autofocus: property.autofocus,
          contentPadding: EdgeInsets.zero
          // activeTrackColor: Colors.lightGreenAccent,
          // activeColor: Colors.green,

          );
    });
  }
}
