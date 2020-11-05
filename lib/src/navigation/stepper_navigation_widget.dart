import 'package:flutter/material.dart';
import 'package:naples/naples.dart';
import 'package:naples/widgets/actions_widget.dart';
import 'package:provider/provider.dart';
import 'package:naples/src/navigation/navigation.dart';
import 'package:naples/src/common/common.dart';

/// This widget depends on these providers:
/// - NavigationModel
class StepperNavigationWidget extends StatefulWidget {
  @override
  _StepperNavigationWidgetState createState() => _StepperNavigationWidgetState();
}

class _StepperNavigationWidgetState extends State<StepperNavigationWidget> {
  bool _isValid = false;

  @override
  Widget build(BuildContext context) {
    final navigationModel = context.watch<NavigationModel>();
    final currentStateViewModel = navigationModel.currentStateViewModel;
    final _viewModelKey = GlobalObjectKey<ValidableState>(currentStateViewModel);

    if (currentStateViewModel == null) return SizedBox();

    return Stepper(
      key: UniqueKey(),
      steps: [
        ...navigationModel.history.map((e) => Step(
              title: e == null ? null : Text(e.title(context)),
              content: e.builder(context: context),
              state: StepState.complete,
            )),
        Step(
            title:
                currentStateViewModel == null ? null : Text(currentStateViewModel.title(context)),
            content: currentStateViewModel.builder(
              key: _viewModelKey,
              context: context,
              onChanged: () {
                if (_isValid != _viewModelKey.currentState.valid) {
                  setState(() {
                    _isValid = _viewModelKey.currentState.valid;
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
