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
    try {
      // lenient: true makes missing values render as empty strings instead of throwing
      var t = Template(template, htmlEscapeValues: false, lenient: true);
      var output = t.renderString(source.mustacheValues(locale));
      return builder(output);
    } catch (e) {
      // If template parsing fails (e.g., malformed mustache tags),
      // fall back to rendering the original template without processing
      return builder(template);
    }
  }
}
