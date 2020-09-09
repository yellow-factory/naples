import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yellow_naples/view_models/properties.dart';

class SwitchViewModelPropertyWidget extends StatelessWidget {
  final BoolViewModelProperty property;

  SwitchViewModelPropertyWidget(this.property);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return SwitchListTile(
          title: Text(property.label()),
          controlAffinity: _controlAffinity,
          value: property.currentValue,
          onChanged: property.editable
              ? (value) {
                  setState(() {
                    property.currentValue = value;
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

  ListTileControlAffinity get _controlAffinity =>
      property.widgetPosition == BoolWidgetPosition.Leading
          ? ListTileControlAffinity.leading
          : ListTileControlAffinity.trailing;
}
