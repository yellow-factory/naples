import 'package:flutter/material.dart';
import 'package:naples/src/common/common.dart';
import 'package:naples/widgets/linkyfied_widget.dart';

class CommentProperty extends StatelessWidget implements Expandable {
  final int flex;
  final String comment;
  final TextStyle textStyle;
  final TextStyle linkStyle;
  final TextAlign textAlign;
  final double topPadding;
  final double bottomPadding;

  CommentProperty(
      {Key key,
      @required this.comment,
      this.flex = 99,
      this.textStyle,
      this.textAlign,
      this.linkStyle,
      this.topPadding,
      this.bottomPadding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding ?? 0.0, bottom: bottomPadding ?? 0.0),
      child: LinkyfiedWidget(
        text: comment,
        linkStyle: linkStyle,
        textAlign: textAlign,
        textStyle: textStyle,
      ),
    );
  }
}
