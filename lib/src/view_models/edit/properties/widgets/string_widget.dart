import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naples/src/view_models/edit/properties/text_property.dart';
import 'package:naples/src/view_models/edit/properties/string_property.dart';
import 'package:provider/provider.dart';
import 'text_widget.dart';

class StringViewModelPropertyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final property = context.watch<StringProperty>();
    return ChangeNotifierProvider<TextProperty>.value(
        value: property, child: TextViewModelPropertyWidget());
  }
}
