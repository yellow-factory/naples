import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naples/view_models/properties/properties.dart';
import 'package:provider/provider.dart';

class TextViewModelPropertyWidget extends StatefulWidget {
  final TextInputType textInputType;
  final List<TextInputFormatter> textInputFormatters;

  TextViewModelPropertyWidget({this.textInputType, this.textInputFormatters});

  @override
  _TextViewModelPropertyWidgetState createState() => _TextViewModelPropertyWidgetState();
}

class _TextViewModelPropertyWidgetState extends State<TextViewModelPropertyWidget> {
  @override
  Widget build(BuildContext context) {
    final property = context.watch<TextViewModelProperty>();
    final formFieldKey = GlobalObjectKey(property);
    return TextFormField(
      key: formFieldKey,
      initialValue: property.serializedValue,
      decoration: InputDecoration(
        //filled: true,
        hintText: property.hint != null ? property.hint() : null,
        labelText: property.label != null ? property.label() : null,
      ),
      enabled: property.editable,
      autofocus: property.autofocus,
      validator: (_) => property.validate(),
      keyboardType: widget.textInputType,
      inputFormatters: [
        if (widget.textInputFormatters != null) ...widget.textInputFormatters,
        LengthLimitingTextInputFormatter(property.maxLength),
      ],
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: property.obscureText,
      //maxLength: property.maxLength,

      // minLines: 1,
      // maxLines: 3,
      onChanged: (value) {
        property.serializedValue = value;
        if (property.valid) property.update();
      },
    );
  }
}
