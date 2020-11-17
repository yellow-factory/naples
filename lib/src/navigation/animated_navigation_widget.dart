import 'package:flutter/material.dart';
import 'package:naples/src/widgets/back_forward_animation_widget.dart';
import 'package:naples/src/navigation/navigation.dart';
import 'package:navy/navy.dart';
import 'package:provider/provider.dart';

class AnimatedNavigationWidget<T> extends StatefulWidget {
  final Duration duration;
  final Duration reverseDuration;
  final FunctionOf1<T, Widget> currentStepBuilder;

  AnimatedNavigationWidget({
    @required this.currentStepBuilder,
    this.duration = const Duration(milliseconds: 500),
    this.reverseDuration = const Duration(milliseconds: 500),
    Key key,
  }) : super(key: key);

  @override
  _AnimatedNavigationWidgetState createState() => _AnimatedNavigationWidgetState();
}

class _AnimatedNavigationWidgetState extends State<AnimatedNavigationWidget> {
  final key = GlobalKey<BackForwardAnimationWidgetState>();
  @override
  Widget build(BuildContext context) {
    var navigationModel = context.watch<NavigationModel>();
    return BackForwardAnimationWidget(
      key: key,
      duration: widget.duration,
      reverseDuration: widget.duration,
      child: Container(
        key: ValueKey(navigationModel.currentState),
        child: widget.currentStepBuilder(navigationModel.currentState),
      ),
    );
  }
}
