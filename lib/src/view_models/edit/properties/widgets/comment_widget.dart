import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naples/src/view_models/edit/properties/comment_property.dart';
import 'package:provider/provider.dart';

class CommentViewModelPropertyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final property = context.watch<CommentProperty>();
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
