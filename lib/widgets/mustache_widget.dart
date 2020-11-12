import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mustache_template/mustache.dart';
import 'package:navy/navy.dart';

class MustacheWidget<T> extends StatelessWidget {
  final T source;
  final String template;
  final FunctionOf1<String, Widget> builder;

  MustacheWidget({
    @required this.source,
    @required this.template,
    @required this.builder,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var t = new Template(template);
    var transSource = json.decode(json.encode(source));
    var output = t.renderString(transSource);
    return builder(output);
  }
}
