import 'package:flutter/material.dart';
import 'package:naples/naples.dart';
import 'package:naples/src/widgets/back_forward_animation_widget.dart';
import 'package:naples/src/navigation/navigation.dart';
import 'package:naples/src/widgets/actions_widget.dart';
import 'package:navy/navy.dart';
import 'package:provider/provider.dart';

class StepNavigationWidget<T> extends StatefulWidget {
  final FunctionOf1<T, Widget>? currentStepTitleBuilder;
  final FunctionOf2<T, ActionOf1<bool>, Widget> currentStepContentBuilder;

  StepNavigationWidget({
    Key? key,
    this.currentStepTitleBuilder,
    required this.currentStepContentBuilder,
  }) : super(key: key);

  @override
  _StepNavigationWidgetState<T> createState() => _StepNavigationWidgetState<T>();
}

class _StepNavigationWidgetState<T> extends State<StepNavigationWidget<T>> {
  final _animationKey = GlobalKey<BackForwardAnimationWidgetState>();
  bool _isValid = false;

  NaplesLocalizations get naplesLocalizations =>
      NaplesLocalizations.of(context) ??
      (throw Exception("NaplesLocalizations not found in the context"));

  @override
  Widget build(BuildContext context) {
    var navigationModel = context.watch<NavigationModel<T>>();
    final currentState = navigationModel.currentState;

    if (navigationModel.currentState == null) return SizedBox();

    return BackForwardAnimationWidget(
      key: _animationKey,
      child: Column(
        key: ValueKey(currentState),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (widget.currentStepTitleBuilder != null) widget.currentStepTitleBuilder!(currentState),
          widget.currentStepContentBuilder(
            currentState,
            (bool valid) {
              if (_isValid != valid) {
                setState(() {
                  _isValid = valid;
                });
              }
            },
          ),
          ActionsListWidget(
            actions: <ActionWidget>[
              ActionWidget(
                title: navigationModel.canGoForward
                    ? naplesLocalizations.continua
                    : naplesLocalizations.finalitza,
                action: _isValid
                    ? () async {
                        _animationKey.currentState?.direction =
                            BackForwardAnimationDirection.Forward;
                        await navigationModel.forward();
                      }
                    : null,
                primary: true,
              ),
              if (navigationModel.canGoBack)
                ActionWidget(
                  title: naplesLocalizations.torna,
                  action: () async {
                    _animationKey.currentState?.direction = BackForwardAnimationDirection.Back;
                    await navigationModel.back();
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
