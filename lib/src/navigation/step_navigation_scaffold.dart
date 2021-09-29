import 'package:flutter/material.dart';
import 'package:naples/navigation.dart';
import 'package:navy/navy.dart';

class StepNavigationScaffold<T> extends StatelessWidget {
  final String? title;
  final FunctionOf1<T, Widget>? currentStepTitleBuilder;
  final FunctionOf2<T, ActionOf1<bool>, Widget> currentStepContentBuilder;

  StepNavigationScaffold({
    Key? key,
    this.title,
    this.currentStepTitleBuilder,
    required this.currentStepContentBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title ?? '')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: StepNavigationWidget(
          currentStepTitleBuilder: currentStepTitleBuilder,
          currentStepContentBuilder: currentStepContentBuilder,
        ),
      ),
    );
  }
}
