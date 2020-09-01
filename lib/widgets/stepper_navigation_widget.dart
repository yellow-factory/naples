import 'dart:math';

import 'package:flutter/material.dart';
import 'package:yellow_naples/view_models/common.dart';
import 'package:yellow_naples/view_models/view_model.dart';
import 'package:provider/provider.dart';
import 'package:yellow_naples/navigation/navigation.dart';

import 'actions_widget.dart';
import 'base_scaffold_widget.dart';

/// This widget depends on these providers:
/// - NavigationModel
/// - ViewModel
class StepperNavigationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var navigationModel = Provider.of<StepsNavigationModel>(context, listen: false);

    //Tracks the current viewmodel of the NavigationModel that must be of RawStepViewModel
    var currentViewModel =
        context.select<NavigationModel, ViewModel>((nm) => nm.currentStateViewModel.viewModel)
            as RawStepViewModel;

    //Whenever ViewModel changes the widget must be rebuild
    context.watch<ViewModel>() as RawStepViewModel;

    var w = BaseScaffoldWidget(
        child: Stepper(
            key: Key(Random.secure()
                .nextDouble()
                .toString()), //This is necessary to avoid an error changing the number of steps
            steps: [
              ...navigationModel.history.map((e) => Step(
                    title: Text(e.viewModel.title),
                    content: e.viewModel.widget,
                  )),
              Step(
                  title: Text(currentViewModel.title),
                  content: currentViewModel.widget,
                  isActive: true,
                  state: StepState.editing),
            ],
            currentStep: navigationModel.history.length,
            type: StepperType.vertical,
            onStepContinue: () => currentViewModel.nextStep(),
            onStepCancel: () => currentViewModel.previousStep(),
            controlsBuilder: (BuildContext context,
                {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
              return Container(
                  margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  child: ActionsWidget(
                    actions: <ActionWrap>[
                      ActionWrap(
                        title: currentViewModel.hasNextStep ? "Continua" : "Finalitza",
                        action: () => onStepContinue(),
                      ),
                      if (currentViewModel.hasPreviousStep)
                        ActionWrap(
                          title: "Torna",
                          action: () => onStepCancel(),
                        ),
                    ],
                  ));
            }));

    //Registers the new ViewModel in order to lookup for changes
    return ChangeNotifierProvider<ViewModel>.value(value: currentViewModel, child: w);
  }
}
