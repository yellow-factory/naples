import 'package:flutter/widgets.dart';
import 'package:naples/src/common/common.dart';
import 'package:naples/widgets/linkyfied_widget.dart';
import 'package:naples/widgets/markdown_widget.dart';

class MustacheProperty<T> extends StatelessWidget implements Expandable {
  final int flex;
  final T source;
  final String template;
  final bool processMarkdown;
  final double height;

  MustacheProperty({
    Key key,
    this.flex = 99,
    @required this.source,
    @required this.template,
    this.processMarkdown = false,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (processMarkdown)
      return MarkdownWidget(
        template: template,
        height: height,
      );
    var linkyfied = LinkyfiedWidget(
      text: template,
    );
    if (height != null)
      return SizedBox(
        height: height,
        child: linkyfied,
      );
    return linkyfied;
  }
}
