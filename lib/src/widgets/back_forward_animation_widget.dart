import 'package:flutter/material.dart';

class BackForwardAnimationWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration reverseDuration;
  final bool showOnlyInWidget;
  const BackForwardAnimationWidget({
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.reverseDuration = const Duration(milliseconds: 500),
    this.showOnlyInWidget = false,
    super.key,
  });

  @override
  BackForwardAnimationWidgetState createState() => BackForwardAnimationWidgetState();
}

enum BackForwardAnimationDirection { back, forward }

class BackForwardAnimationWidgetState extends State<BackForwardAnimationWidget> {
  BackForwardAnimationDirection _direction = BackForwardAnimationDirection.forward;
  BackForwardAnimationDirection get direction => _direction;
  set direction(BackForwardAnimationDirection value) {
    setState(() {
      _direction = value;
    });
  }

  double get directionV => direction == BackForwardAnimationDirection.forward ? 1 : -1;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: widget.duration,
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      reverseDuration: widget.reverseDuration,
      layoutBuilder: widget.showOnlyInWidget
          ? (currentChild, previousChildren) {
              if (currentChild == null) return const Placeholder();
              return currentChild;
            }
          : AnimatedSwitcher.defaultLayoutBuilder,
      transitionBuilder: (Widget child, Animation<double> animation) {
        var isInWidget = child == widget.child;
        Animation<Offset> position;
        if (isInWidget) {
          position = Tween<Offset>(
            begin: Offset(1 * directionV, 0),
            end: Offset.zero,
          ).animate(animation);
        } else {
          position = Tween<Offset>(
            begin: Offset(-1 * directionV, 0),
            end: Offset.zero,
          ).animate(animation);
        }

        return ClipRect(
          child: SlideTransition(
            position: position,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
