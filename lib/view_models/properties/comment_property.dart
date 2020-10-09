
import 'package:flutter/material.dart';
import 'package:naples/view_models/properties/widgets/comment_view_model_property_widget.dart';
import 'package:provider/provider.dart';
import 'package:navy/navy.dart';
import 'package:naples/view_models/view_model.dart';

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
