import 'package:flutter/material.dart';
import 'package:naples/src/navigation/navigation.dart';
import 'package:navy/navy.dart';

class NavigationWidget<T> extends StatefulWidget {
  final NavigationModel<T> navigationModel;
  final FunctionOf1<T, Widget> currentStepBuilder;

  NavigationWidget({
    Key? key,
    required this.currentStepBuilder,
    required this.navigationModel,
  }) : super(key: key);

  @override
  State<NavigationWidget<T>> createState() => _NavigationWidgetState<T>();
}

class _NavigationWidgetState<T> extends State<NavigationWidget<T>> {
  late T _currentState;

  NavigationModel<T> get navigationModel => widget.navigationModel;

  @override
  void initState() {
    super.initState();
    _setNavigationState();
    navigationModel.addListener(_onNavigationModelChanged);
  }

  @override
  void didUpdateWidget(covariant NavigationWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    //Pot ser que el widget hagi canviat,
    //per això ens hem d'assegurar d'oblidar l'anterior i actuar sobre el nou
    if (widget.navigationModel != oldWidget.navigationModel) {
      oldWidget.navigationModel.removeListener(_onNavigationModelChanged);
      widget.navigationModel.addListener(_onNavigationModelChanged);
    }
  }

  @override
  void dispose() {
    navigationModel.removeListener(_onNavigationModelChanged);
    super.dispose();
  }

  void _setNavigationState() {
    _currentState = navigationModel.currentState;
  }

  void _onNavigationModelChanged() {
    setState(() {
      _setNavigationState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.currentStepBuilder(_currentState);
  }
}
