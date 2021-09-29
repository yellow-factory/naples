import 'package:flutter/material.dart';
import 'package:naples/src/navigation/navigation.dart';
import 'package:navy/navy.dart';
import 'package:provider/provider.dart';

class NavigationWidget<T> extends StatelessWidget {
  final FunctionOf1<T, Widget> currentStepBuilder;

  NavigationWidget({Key? key, required this.currentStepBuilder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var navigationModel = context.watch<NavigationModel<T>>();
    return currentStepBuilder(navigationModel.currentState);
  }
}
