import 'package:flutter/material.dart';
import 'package:naples/navigation.dart';
import 'package:naples/widgets/base_scaffold_widget.dart';

class ScaffoldStepNavigationWidget<T> extends StatelessWidget {
  final String title;

  ScaffoldStepNavigationWidget({
    this.title,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldWidget(
      title: title,
      child: StepNavigationWidget(),
    );
  }
}

//TODO: És necessari?
