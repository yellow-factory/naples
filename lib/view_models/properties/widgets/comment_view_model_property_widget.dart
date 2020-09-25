import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yellow_naples/view_models/properties/properties.dart';
import 'package:provider/provider.dart';

class CommentViewModelPropertyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final property = context.watch<CommentLayoutMember>();
    return Padding(
      key: UniqueKey(),
      padding:
          EdgeInsets.only(top: property.topPadding ?? 0.0, bottom: property.bottomPadding ?? 0.0),
      child: Text(
        property.comment(),
        style: TextStyle(fontStyle: property.fontStyle, fontWeight: property.fontWeight),
        textAlign: property.textAlign,
      ),
    );
  }
}
