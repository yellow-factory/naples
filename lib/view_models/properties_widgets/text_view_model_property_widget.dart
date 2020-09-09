import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yellow_naples/view_models/properties.dart';

enum TextViewModelPropertyWidgetType { String, Number }

class TextViewModelPropertyWidget extends StatelessWidget {
  final TextViewModelProperty property;
  final TextViewModelPropertyWidgetType type;

  TextViewModelPropertyWidget(this.property, {this.type: TextViewModelPropertyWidgetType.String});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: property.controller,
        decoration: InputDecoration(
          //filled: true,
          hintText: property.hint != null ? property.hint() : null,
          labelText: property.label(),
        ),
        enabled: property.editable,
        autofocus: property.autofocus,
        validator: (_) => property.validate(),
        keyboardType: _getTextInputType(),
        inputFormatters: _getTextInputFormatters());
  }

  TextInputType _getTextInputType() {
    switch (type) {
      case TextViewModelPropertyWidgetType.Number:
        return TextInputType.number;
      default:
        return null;
    }
  }

  List<TextInputFormatter> _getTextInputFormatters() {
    switch (type) {
      case TextViewModelPropertyWidgetType.Number:
        return <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly];
      default:
        return null;
    }
  }
}
