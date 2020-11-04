import 'package:flutter/material.dart';
import 'package:naples/common.dart';
import 'package:naples/naples.dart';
import 'package:naples/widgets/back_forward_animation_widget.dart';
import 'package:naples/src/navigation/navigation.dart';
import 'package:naples/widgets/actions_widget.dart';
import 'package:provider/provider.dart';

class StepNavigationWidget extends StatefulWidget {
  @override
  _StepNavigationWidgetState createState() => _StepNavigationWidgetState();
}

class _StepNavigationWidgetState extends State<StepNavigationWidget> {
  final _animationKey = GlobalKey<BackForwardAnimationWidgetState>();
  bool _isValid = false;

  @override
  Widget build(BuildContext context) {
    final _viewModelKey = GlobalKey<ValidableState>();
    var navigationModel = context.watch<NavigationModel>();
    final currentStateViewModel = navigationModel.currentStateViewModel;

    if (navigationModel.currentStateViewModel == null) return SizedBox();
    return BackForwardAnimationWidget(
      key: _animationKey,
      child: Column(
        key: ValueKey(currentStateViewModel.state.toString()),
        children: <Widget>[
          currentStateViewModel.builder(
            _viewModelKey,
            context,
            () {
              setState(() {
                _isValid = _viewModelKey.currentState.valid;
              });
            },
          ),
          ActionsListWidget(
            actions: <ActionWidget>[
              ActionWidget(
                title: navigationModel.canGoForward
                    ? NaplesLocalizations.of(context).continua
                    : NaplesLocalizations.of(context).finalitza,
                action: _isValid
                    ? () async {
                        _animationKey.currentState.direction =
                            BackForwardAnimationDirection.Forward;
                        await navigationModel.forward();
                      }
                    : null,
                primary: true,
              ),
              if (navigationModel.canGoBack)
                ActionWidget(
                  title: NaplesLocalizations.of(context).torna,
                  action: () async {
                    _animationKey.currentState.direction = BackForwardAnimationDirection.Back;
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
