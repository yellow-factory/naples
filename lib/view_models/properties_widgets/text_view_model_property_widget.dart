import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yellow_naples/view_models/properties.dart';
import 'package:provider/provider.dart';

class TextViewModelPropertyWidget extends StatelessWidget {
  final TextInputType textInputType;
  final List<TextInputFormatter> textInputFormatters;

  TextViewModelPropertyWidget({this.textInputType, this.textInputFormatters});

  @override
  Widget build(BuildContext context) {
    final property = context.watch<TextViewModelProperty>();
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
        keyboardType: textInputType,
        inputFormatters: textInputFormatters);
  }

  // TextInputType _getTextInputType() {
  //   switch (type) {
  //     case TextViewModelPropertyWidgetType.Number:
  //       return TextInputType.number;
  //     default:
  //       return null;
  //   }
  // }

  // List<TextInputFormatter> _getTextInputFormatters() {
  //   switch (type) {
  //     case TextViewModelPropertyWidgetType.Number:
  //       return <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly];
  //     default:
  //       return null;
  //   }
  // }
}
