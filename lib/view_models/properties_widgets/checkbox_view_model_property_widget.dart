import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yellow_naples/view_models/properties.dart';

class CheckboxViewModelPropertyWidget extends StatelessWidget {
  final BoolViewModelProperty property;

  CheckboxViewModelPropertyWidget(this.property);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return CheckboxListTile(
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
          contentPadding: EdgeInsets.zero);
    });
  }

  ListTileControlAffinity get _controlAffinity =>
      property.widgetPosition == BoolWidgetPosition.Leading
          ? ListTileControlAffinity.leading
          : ListTileControlAffinity.trailing;
}
