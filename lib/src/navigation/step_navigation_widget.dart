import 'package:flutter/material.dart';
import 'package:naples/widgets/back_forward_animation_widget.dart';
import 'package:naples/src/navigation/navigation.dart';
import 'package:naples/widgets/actions_widget.dart';
import 'package:provider/provider.dart';

class StepNavigationWidget extends StatefulWidget {
  @override
  _StepNavigationWidgetState createState() => _StepNavigationWidgetState();
}

class _StepNavigationWidgetState extends State<StepNavigationWidget> {
  final key = GlobalKey<BackForwardAnimationWidgetState>();
  @override
  Widget build(BuildContext context) {
    var navigationModel = context.watch<NavigationModel>();
    if (navigationModel.currentStateViewModel == null) return SizedBox();
    return BackForwardAnimationWidget(
      key: key,
      child: Column(
        key: ValueKey(navigationModel.currentStateViewModel.state.toString()),
        children: <Widget>[
          navigationModel.currentStateViewModel.builder(context),
          ActionsWidget(
            actions: <ActionWrap>[
              ActionWrap(
                navigationModel.canGoForward ? "Continua" : "Finalitza",
                action: () async {
                  key.currentState.direction = BackForwardAnimationDirection.Forward;
                  await navigationModel.forward();
                },
                primary: true,
              ),
              if (navigationModel.canGoBack)
                ActionWrap(
                  "Torna",
                  action: () async {
                    key.currentState.direction = BackForwardAnimationDirection.Back;
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

//TODO: Localize
