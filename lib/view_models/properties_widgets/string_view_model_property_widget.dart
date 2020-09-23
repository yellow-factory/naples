import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yellow_naples/view_models/properties.dart';
import 'package:provider/provider.dart';
import 'text_view_model_property_widget.dart';

class StringViewModelPropertyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final property = context.watch<StringViewModelProperty>();
    return ChangeNotifierProvider<TextViewModelProperty>.value(
        value: property, child: TextViewModelPropertyWidget());
  }
}
