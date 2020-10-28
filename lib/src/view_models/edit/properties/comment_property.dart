import 'package:flutter/material.dart';
import 'package:naples/widgets/expandable.dart';

class CommentProperty extends Expandable {
  final String comment;
  final FontStyle fontStyle;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final double topPadding;
  final double bottomPadding;

  CommentProperty(
      {Key key,
      @required this.comment,
      int flex = 99,
      this.fontStyle,
      this.textAlign,
      this.fontWeight,
      this.topPadding,
      this.bottomPadding})
      : super(key: key, flex: flex);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding ?? 0.0, bottom: bottomPadding ?? 0.0),
      child: Text(
        comment,
        style: TextStyle(fontStyle: fontStyle, fontWeight: fontWeight),
        textAlign: textAlign,
      ),
    );
  }
}
