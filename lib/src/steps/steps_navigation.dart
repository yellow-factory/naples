import 'package:flutter/widgets.dart';
import 'package:naples/src/navigation/navigation.dart';
import 'package:navy/navy.dart';

abstract class StepsNavigationModel<T> extends NavigationModel<T> {
  final FunctionOf1<BuildContext, String> title;

  StepsNavigationModel(
    FunctionOf0<StateViewModel<T>> defaultCreateViewModelFunction, {
    this.title,
  }) : super(
          defaultCreateViewModelFunction,
        );
}
