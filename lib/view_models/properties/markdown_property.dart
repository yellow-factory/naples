import 'package:flutter/material.dart';
import 'package:naples/view_models/properties/widgets/markdown_widget.dart';
import 'package:naples/view_models/properties/widgets/sized_markdown_widget.dart';
import 'package:naples/view_models/view_model.dart';
import 'package:navy/navy.dart';
import 'package:provider/provider.dart';

class MarkdownProperty extends ViewProperty {
  final FunctionOf0<String> markdown;
  final double width;
  final double height;

  MarkdownProperty(
    this.markdown, {
    int flex = 99,
    PredicateOf0 isVisible,
    this.width,
    this.height,
  }) : super(
          flex: flex,
          isVisible: isVisible,
        );

  @override
  Widget get widget {
    return ChangeNotifierProvider<MarkdownProperty>.value(
      value: this,
      child: width == null && height == null ? MarkdownWidget() : SizedMarkdownWidget(),
    );
  }
}
