import 'package:flutter/material.dart';
import 'package:naples/src/widgets/back_forward_animation_widget.dart';
import 'package:naples/src/navigation/navigation.dart';
import 'package:navy/navy.dart';
import 'package:provider/provider.dart';

class AnimatedNavigationWidget<T> extends StatefulWidget {
  final Duration duration;
  final Duration reverseDuration;
  final FunctionOf1<T, Widget> currentStepBuilder;

  const AnimatedNavigationWidget({
    required this.currentStepBuilder,
    this.duration = const Duration(milliseconds: 500),
    this.reverseDuration = const Duration(milliseconds: 500),
    Key? key,
  }) : super(key: key);

  @override
  _AnimatedNavigationWidgetState<T> createState() => _AnimatedNavigationWidgetState<T>();
}

class _AnimatedNavigationWidgetState<T> extends State<AnimatedNavigationWidget<T>> {
  final key = GlobalKey<BackForwardAnimationWidgetState>();
  @override
  Widget build(BuildContext context) {
    var navigationModel = context.watch<NavigationModel<T>>();
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
