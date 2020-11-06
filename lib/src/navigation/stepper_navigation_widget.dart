import 'package:flutter/material.dart';
import 'package:naples/naples.dart';
import 'package:naples/widgets/actions_widget.dart';
import 'package:navy/navy.dart';
import 'package:provider/provider.dart';
import 'package:naples/src/navigation/navigation.dart';

/// This widget depends on these providers:
/// - NavigationModel
class StepperNavigationWidget<T> extends StatefulWidget {
  final FunctionOf1<T, Widget> currentStepTitleBuilder;
  final FunctionOf2<T, ActionOf1<bool>, Widget> currentStepContentBuilder;

  StepperNavigationWidget({
    Key key,
    @required this.currentStepTitleBuilder,
    @required this.currentStepContentBuilder,
  });

  @override
  _StepperNavigationWidgetState createState() => _StepperNavigationWidgetState();
}

class _StepperNavigationWidgetState extends State<StepperNavigationWidget> {
  bool _isValid = false;

  @override
  Widget build(BuildContext context) {
    final navigationModel = context.watch<NavigationModel>();
    final currentState = navigationModel.currentState;

    if (currentState == null) return SizedBox();

    //In order to work correctly, the stepper key must be related with the number
    //of steps. If the build is triggered by a change in the number of steps we have
    //to change the key. If not we can keep the same key in order to mantain the
    //link with the state (valid).

    return Stepper(
      key: ValueKey(navigationModel.history.length),
      steps: [
        ...navigationModel.history.map((e) => Step(
              title: widget.currentStepTitleBuilder(e),
              //Because we change the number of steps we only care about the current step
              content: SizedBox(),
              state: StepState.complete,
            )),
        Step(
            title: widget.currentStepTitleBuilder(currentState),
            content: widget.currentStepContentBuilder(
              currentState,
              (bool valid) {
                if (_isValid != valid) {
                  setState(() {
                    _isValid = valid;
                  });
                }
              },
            ),
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
            child: ActionsListWidget(
              actions: <ActionWidget>[
                ActionWidget(
                  title: navigationModel.canGoForward
                      ? NaplesLocalizations.of(context).continua
                      : NaplesLocalizations.of(context).finalitza,
                  action: _isValid ? () => onStepContinue() : null,
                  primary: true,
                ),
                if (navigationModel.canGoBack)
                  ActionWidget(
                    title: NaplesLocalizations.of(context).torna,
                    action: () => onStepCancel(),
                  ),
              ],
            ));
      },
    );
  }
}
