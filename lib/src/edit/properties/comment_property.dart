import 'package:flutter/material.dart';
import 'package:naples/src/common/common.dart';
import 'package:naples/src/widgets/linkyfied_widget.dart';

class CommentProperty extends StatelessWidget implements Expandable {
  @override
  final int flex;
  final String comment;
  final TextStyle? textStyle;
  final TextStyle? linkStyle;
  final TextAlign? textAlign;
  final double topPadding;
  final double bottomPadding;

  const CommentProperty(
      {Key? key,
      required this.comment,
      this.flex = 99,
      this.textStyle,
      this.textAlign,
      this.linkStyle,
      this.topPadding = 0.0,
      this.bottomPadding = 0.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
      child: LinkyfiedWidget(
        text: comment,
        linkStyle: linkStyle,
        textAlign: textAlign,
        textStyle: textStyle,
      ),
    );
  }
}
