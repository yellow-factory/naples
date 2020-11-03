import 'package:flutter/material.dart';
import 'package:naples/naples.dart';
import 'package:naples/widgets/actions_widget.dart';
import 'package:provider/provider.dart';
import 'package:naples/src/navigation/navigation.dart';

/// This widget depends on these providers:
/// - NavigationModel
/// - ViewModel
class StepperNavigationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var navigationModel = Provider.of<NavigationModel>(context, listen: false);

    //Tracks the current viewmodel of the NavigationModel that must be of RawStepViewModel
    var currentStateViewModel =
        context.select<NavigationModel, StateViewModel>((nm) => nm.currentStateViewModel);

    if (currentStateViewModel == null) return SizedBox();

    return Stepper(
      key: UniqueKey(),
      steps: [
        ...navigationModel.history.map((e) => Step(
              title: e == null ? null : Text(e.title(context)),
              content: e.builder(context),
              state: StepState.complete,
            )),
        Step(
            title:
                currentStateViewModel == null ? null : Text(currentStateViewModel.title(context)),
            content: currentStateViewModel.builder(context),
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
  }
}


//TODO: Localize