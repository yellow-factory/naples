import 'package:flutter/material.dart';
import 'package:naples/navigation.dart';
import 'package:naples/src/navigation/will_pop_scope_navigation_widget.dart';
import 'package:naples/widgets/base_scaffold_widget.dart';

class ScaffoldStepNavigationWidget<T> extends StatelessWidget {
  final String title;

  ScaffoldStepNavigationWidget({
    this.title,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScopeNavigationWidget(
      child: BaseScaffoldWidget(
        title: title,
        child: StepNavigationWidget(),
      ),
    );
  }
}
