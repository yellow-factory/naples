import 'package:flutter/material.dart';
import 'package:naples/widgets/expandable.dart';
import 'package:navy/navy.dart';
import 'package:flutter_markdown/flutter_markdown.dart' as fmd;
import 'package:markdown/markdown.dart' as md;

class MarkdownProperty extends Expandable {
  final int flex;
  final FunctionOf0<String> markdown;
  final double width;
  final double height;

  MarkdownProperty({
    Key key,
    @required this.markdown,
    this.flex = 99,
    PredicateOf0 isVisible,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final m = fmd.MarkdownBody(
      data: markdown(),
      extensionSet: md.ExtensionSet.gitHubWeb,
    );
    if (width == null && height == null) return m;
    return SizedBox(height: height, width: width, child: m);
  }
}
