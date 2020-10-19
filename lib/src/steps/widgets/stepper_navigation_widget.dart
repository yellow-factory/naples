import 'package:flutter/material.dart';
import 'package:naples/naples.dart';
import 'package:naples/src/steps/step_view_model.dart';
import 'package:naples/src/steps/steps_navigation.dart';
import 'package:naples/src/view_models/view_model.dart';
import 'package:naples/widgets/actions_widget.dart';
import 'package:provider/provider.dart';
import 'package:naples/src/navigation/navigation.dart';

/// This widget depends on these providers:
/// - NavigationModel
/// - ViewModel
class StepperNavigationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var navigationModel = Provider.of<StepsNavigationModel>(context, listen: false);

    //Tracks the current viewmodel of the NavigationModel that must be of RawStepViewModel
    var currentStateViewModel =
        context.select<NavigationModel, StateViewModel>((nm) => nm.currentStateViewModel);

    if (currentStateViewModel == null || currentStateViewModel.viewModel == null)
      return Container();
    var currentViewModel = currentStateViewModel.viewModel;

    //Whenever ViewModel changes the widget must be rebuild
    context.watch<ViewModel>();

    var w = Stepper(
      key: UniqueKey(),
      steps: [
        ...navigationModel.history.map((e) => Step(
              title: Text(e.viewModel.title),
              content: e.viewModel.widget,
              state: StepState.complete,
            )),
        Step(
            title: Text(currentViewModel.title),
            content: currentViewModel.widget,
            isActive: true,
            state: StepState.editing),
      ],
      currentStep: navigationModel.history.length,
      type: StepperType.vertical,
      onStepContinue: () => navigationModel.forward(),
      onStepCancel: () => navigationModel.back(),

      //TODO: execute arbitrary transitions when possible
      //onStepTapped: (step) {
      //  currentViewModel.gotoStep();
      //},
      controlsBuilder: (BuildContext context,
          {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
        return Container(
            margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            child: ActionsWidget(
              actions: <ActionWrap>[
                ActionWrap(
                  navigationModel.canGoForward
                      ? NaplesLocalizations.of(context).continua
                      : NaplesLocalizations.of(context).finalitza,
                  action: () => onStepContinue(),
                  primary: true,
                ),
                if (navigationModel.canGoBack)
                  ActionWrap(
                    NaplesLocalizations.of(context).torna,
                    action: () => onStepCancel(),
                  ),
              ],
            ));
      },
    );

    //Registers the new ViewModel in order to lookup for changes
    return ChangeNotifierProvider<ViewModel>.value(value: currentViewModel, child: w);
  }
}
