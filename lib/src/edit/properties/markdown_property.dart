import 'package:flutter/material.dart';
import 'package:naples/src/common/common.dart';
import 'package:naples/widgets/markdown_widget.dart';
import 'package:navy/navy.dart';

class MarkdownProperty extends StatelessWidget implements Expandable {
  final int flex;
  final String markdown;
  final double height;

  MarkdownProperty({
    Key key,
    @required this.markdown,
    this.flex = 99,
    PredicateOf0 isVisible,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MarkdownWidget(
      template: markdown,
      height: height,
    );
  }
}
