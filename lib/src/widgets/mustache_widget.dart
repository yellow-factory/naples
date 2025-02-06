import 'package:flutter/material.dart';
import 'package:mustache_template/mustache.dart';
import 'package:naples/src/common/common.dart';
import 'package:navy/navy.dart';

class MustacheWidget<T extends IMustacheValues> extends StatelessWidget {
  final T source;
  final String template;
  final String locale;
  final FunctionOf1<String, Widget> builder;

  const MustacheWidget({
    required this.source,
    required this.template,
    required this.locale,
    required this.builder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var t = Template(template, htmlEscapeValues: false);
    var output = t.renderString(source.mustacheValues(locale));
    return builder(output);
  }
}
