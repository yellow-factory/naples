import 'package:naples/src/view_models/edit/properties/markdown_property.dart';
import 'package:navy/navy.dart';
import 'package:mustache_template/mustache.dart';
import 'dart:convert';

class MustacheProperty<T> extends MarkdownProperty {
  final T source;

  MustacheProperty(
    this.source,
    FunctionOf0 template, {
    int flex = 99,
    PredicateOf0 isVisible,
    double width,
    double height,
  }) : super(
          template,
          flex: flex,
          isVisible: isVisible,
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
