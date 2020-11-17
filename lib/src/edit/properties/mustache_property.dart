import 'package:flutter/widgets.dart';
import 'package:naples/src/common/common.dart';
import 'package:naples/src/widgets/linkyfied_widget.dart';
import 'package:naples/src/widgets/markdown_widget.dart';
import 'package:naples/src/widgets/mustache_widget.dart';

class MustacheProperty<T extends IMustacheValues> extends StatelessWidget implements Expandable {
  final int flex;
  final T source;
  final String template;
  final String locale;
  final bool processMarkdown;
  final double height;

  MustacheProperty({
    Key key,
    this.flex = 99,
    @required this.source,
    @required this.template,
    @required this.locale,
    this.processMarkdown = false,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MustacheWidget(
      template: template,
      source: source,
      locale: locale,
      builder: (t) {
        //If Markdown...
        if (processMarkdown)
          return MarkdownWidget(
            template: template,
            height: height,
          );

        //By default uses Linkyfi
        var linkyfied = LinkyfiedWidget(
          text: template,
        );
        if (height != null)
          return SizedBox(
            height: height,
            child: linkyfied,
          );
        return linkyfied;
      },
    );
  }
}
