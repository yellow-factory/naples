//import 'dart:async';
import 'package:flutter/material.dart';
import 'package:naples/src/navigation/navigation.dart';
import 'package:naples/src/steps/widgets/stepper_navigation_widget.dart';
import 'package:provider/provider.dart';
import 'package:naples/models.dart';
import 'package:navy/navy.dart';
import 'package:naples/src/view_models/view_model.dart';

abstract class StepsNavigationModel<T> extends NavigationModel<T> {
  final FunctionOf0<String> title;

  StepsNavigationModel(
    BuildContext context,
    T defaultState,
    FunctionOf1<NavigationModel<T>, ViewModel> defaultCreateViewModelFunction, {
    this.title,
  }) : super(
          context,
          defaultState,
          defaultCreateViewModelFunction,
        );

  @override
  Widget get widget {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<StepsNavigationModel<T>>.value(value: this),
        ChangeNotifierProvider<StepsNavigationModel>.value(value: this),
        ChangeNotifierProvider<NavigationModel<T>>.value(value: this),
        ChangeNotifierProvider<NavigationModel>.value(value: this),
        ChangeNotifierProvider<TitleModel>(create: (_) => TitleModel(this.title)),
      ],
      builder: (context, child) {
        //I have to schedule the initialization because provoque a new build of StepperNavigationWidget
        //scheduleMicrotask(() => initialize1(context));
        return ChangeNotifierProvider<ViewModel>(
            create: (_) => currentStateViewModel.viewModel, child: StepperNavigationWidget());
      },
    );
  }
}
