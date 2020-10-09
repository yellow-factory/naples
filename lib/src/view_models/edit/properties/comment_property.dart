import 'package:flutter/material.dart';
import 'package:naples/src/view_models/edit/properties/widgets/comment_widget.dart';
import 'package:provider/provider.dart';
import 'package:navy/navy.dart';
import 'package:naples/src/view_models/edit/properties/view_property.dart';

class CommentProperty extends ViewProperty {
  final FunctionOf0<String> comment;
  final FontStyle fontStyle;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final double topPadding;
  final double bottomPadding;

  CommentProperty(this.comment,
      {int flex = 99,
      PredicateOf0 isVisible,
      this.fontStyle,
      this.textAlign,
      this.fontWeight,
      this.topPadding,
      this.bottomPadding})
      : super(flex: flex, isVisible: isVisible);

  @override
  Widget get widget {
    return ChangeNotifierProvider<CommentProperty>.value(
      value: this,
      child: CommentViewModelPropertyWidget(),
    );
  }
}
