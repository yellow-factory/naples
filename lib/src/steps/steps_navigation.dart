import 'package:flutter/widgets.dart';
import 'package:naples/src/navigation/navigation.dart';
import 'package:navy/navy.dart';

abstract class StepsNavigationModel<T> extends NavigationModel<T> {
  final FunctionOf1<BuildContext, String> title;

  StepsNavigationModel(
    FunctionOf1<NavigationModel<T>, StateViewModel<T>> defaultCreateViewModelFunction, {
    this.title,
  }) : super(
          defaultCreateViewModelFunction,
        );

  // @override
  // Widget get widget {
  //   return MultiProvider(
  //     providers: [
  //       ChangeNotifierProvider<StepsNavigationModel<T>>.value(value: this),
  //       ChangeNotifierProvider<StepsNavigationModel>.value(value: this),
  //       ChangeNotifierProvider<NavigationModel<T>>.value(value: this),
  //       ChangeNotifierProvider<NavigationModel>.value(value: this),
  //       ChangeNotifierProvider<TitleModel>(create: (_) => TitleModel(this.title)),
  //     ],
  //     builder: (context, child) {
  //       //I have to schedule the initialization because provoque a new build of StepperNavigationWidget
  //       //scheduleMicrotask(() => initialize1(context));
  //       return StepperNavigationWidget();
  //     },
  //   );
  // }
}
