import 'package:flutter/material.dart';
import 'package:naples/naples.dart';
import 'package:naples/src/widgets/actions_widget.dart';
import 'package:navy/navy.dart';
import 'package:naples/src/navigation/navigation.dart';

/// This widget depends on these providers:
/// - NavigationModel
class StepperNavigationWidget<T> extends StatefulWidget {
  final FunctionOf1<T, Widget> currentStepTitleBuilder;
  final FunctionOf2<T, ActionOf1<bool>, Widget> currentStepContentBuilder;
  final NavigationModel<T> navigationModel;
  final StepperType stepperType;
  final bool indexedIcons;

  StepperNavigationWidget({
    Key? key,
    required this.currentStepTitleBuilder,
    required this.currentStepContentBuilder,
    required this.navigationModel,
    this.stepperType = StepperType.vertical,
    this.indexedIcons = false,
  });

  @override
  _StepperNavigationWidgetState<T> createState() => _StepperNavigationWidgetState<T>();
}

class _StepperNavigationWidgetState<T> extends State<StepperNavigationWidget<T>> {
  bool _isValid = false;
  late T _currentState;
  late Iterable<T> _history;
  late bool _canGoForward;
  late bool _canGoBack;

  NaplesLocalizations get naplesLocalizations =>
      NaplesLocalizations.of(context) ??
      (throw Exception("NaplesLocalizations not found in the context"));

  @override
  void initState() {
    super.initState();
    var navigationModel = this.widget.navigationModel;
    _setNavigationState(navigationModel);
    navigationModel.addListener(() {
      setState(() {
        _setNavigationState(navigationModel);
      });
    });
  }

  void _setNavigationState(NavigationModel<T> navigationModel) {
    _currentState = navigationModel.currentState;
    _history = navigationModel.history;
    _canGoForward = navigationModel.canGoForward;
    _canGoBack = navigationModel.canGoBack;
  }

  bool back() => this.widget.navigationModel.back();
  bool forward() => this.widget.navigationModel.forward();

  @override
  Widget build(BuildContext context) {
    if (_currentState == null) return SizedBox();

    //In order to work correctly, the stepper key must be related with the number
    //of steps. If the build is triggered by a change in the number of steps we have
    //to change the key. If not we can keep the same key in order to mantain the
    //link with the state (valid).

    return Stepper(
      key: ValueKey(_history.length),
      steps: [
        ..._history.map((e) => Step(
              title: widget.currentStepTitleBuilder(e),
              content: SizedBox(),
              state: widget.indexedIcons ? StepState.indexed : StepState.complete,
            )),
        Step(
            title: widget.currentStepTitleBuilder(_currentState),
            content: widget.currentStepContentBuilder(
              _currentState,
              (bool valid) {
                if (_isValid != valid) {
                  setState(() {
                    _isValid = valid;
                  });
                }
              },
            ),
            isActive: true,
            state: widget.indexedIcons ? StepState.indexed : StepState.editing),
      ],
      currentStep: _history.length,
      type: widget.stepperType,
      onStepContinue: () => forward(),
      onStepCancel: () => back(),

      //TODO: execute arbitrary transitions when possible
      //onStepTapped: (step) {
      //  currentViewModel.gotoStep();
      //},
      controlsBuilder: (
        BuildContext context, {
        VoidCallback? onStepContinue,
        VoidCallback? onStepCancel,
      }) {
        return ifNotNullFunctionOf2(
          onStepContinue,
          onStepCancel,
          (VoidCallback onContinue, VoidCallback onCancel) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: ActionsListWidget(
                actions: <ActionWidget>[
                  ActionWidget(
                    title: _canGoForward
                        ? naplesLocalizations.continua
                        : naplesLocalizations.finalitza,
                    action: _isValid ? () => onContinue() : null,
                    primary: true,
                  ),
                  if (_canGoBack)
                    ActionWidget(
                      title: naplesLocalizations.torna,
                      action: () => onCancel(),
                    ),
                ],
              ),
            );
          },
          SizedBox(),
        );
      },
    );
  }
}
