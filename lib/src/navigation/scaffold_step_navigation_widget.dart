import 'package:flutter/material.dart';
import 'package:naples/navigation.dart';
import 'package:naples/src/navigation/will_pop_scope_navigation_widget.dart';
import 'package:naples/widgets/base_scaffold_widget.dart';
import 'package:navy/navy.dart';

class ScaffoldStepNavigationWidget<T> extends StatelessWidget {
  final String title;
  final FunctionOf1<T, Widget> currentStepTitleBuilder;
  final FunctionOf2<T, ActionOf1<bool>, Widget> currentStepContentBuilder;

  ScaffoldStepNavigationWidget({
    Key key,
    this.title,
    this.currentStepTitleBuilder,
    @required this.currentStepContentBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScopeNavigationWidget(
      child: BaseScaffoldWidget(
        title: title,
        child: StepNavigationWidget(
          currentStepTitleBuilder: currentStepTitleBuilder,
          currentStepContentBuilder: currentStepContentBuilder,
        ),
      ),
    );
  }
}
