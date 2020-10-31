import 'package:flutter/material.dart';
import 'package:naples/src/navigation/navigation.dart';
import 'package:naples/src/navigation/navigation_widget.dart';
import 'package:naples/widgets/actions_widget.dart';
import 'package:provider/provider.dart';

class StepNavigationWidget extends StatefulWidget {
  @override
  _StepNavigationWidgetState createState() => _StepNavigationWidgetState();
}

class _StepNavigationWidgetState extends State<StepNavigationWidget> {
  double xBeginPosition = 1;

  @override
  Widget build(BuildContext context) {
    var navigationModel = context.watch<NavigationModel>();
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      switchInCurve: Curves.easeInOutQuart,
      switchOutCurve: Curves.fastOutSlowIn,
      reverseDuration: const Duration(milliseconds: 0),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SlideTransition(
          child: child,
          position: Tween<Offset>(
            begin: Offset(xBeginPosition, 0),
            end: const Offset(0, 0),
          ).animate(
            CurvedAnimation(
              curve: Curves.decelerate,
              parent: animation,
            ),
          ),
        );
      },
      child: Column(
        key: ValueKey(navigationModel.currentStateViewModel.state),
        children: <Widget>[
          NavigationWidget(),
          ActionsWidget(
            actions: <ActionWrap>[
              ActionWrap(
                navigationModel.canGoForward ? "Continua" : "Finalitza",
                action: () async {
                  setState(() => xBeginPosition = 1);
                  await navigationModel.forward();
                },
                primary: true,
              ),
              if (navigationModel.canGoBack)
                ActionWrap(
                  "Torna",
                  action: () async {
                    setState(() => xBeginPosition = -1);
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
