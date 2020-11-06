import 'package:flutter/widgets.dart';
import 'package:naples/src/edit/properties/markdown_property.dart';
import 'package:navy/navy.dart';
import 'package:mustache_template/mustache.dart';
import 'dart:convert';

class MustacheProperty<T> extends MarkdownProperty {
  final T source;

  MustacheProperty({
    Key key,
    @required this.source,
    FunctionOf0 template,
    int flex = 99,
    double width,
    double height,
  }) : super(
          key: key,
          markdown: template,
          flex: flex,
          width: width,
          height: height,
        );

  @override
  FunctionOf0<String> get markdown {
    var template = new Template(super.markdown());
    var transSource = json.decode(json.encode(source));
    var output = template.renderString(transSource);
    return () => output;
  }
}
