import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naples/src/view_models/edit/properties/text_property.dart';
import 'package:naples/src/view_models/edit/properties/int_property.dart';
import 'package:provider/provider.dart';
import 'text_widget.dart';

class IntViewModelPropertyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final property = context.watch<IntProperty>();
    return ChangeNotifierProvider<TextProperty>.value(
        value: property,
        child: TextViewModelPropertyWidget(
            textInputType: TextInputType.number,
            textInputFormatters: [FilteringTextInputFormatter.digitsOnly]));
  }
}
