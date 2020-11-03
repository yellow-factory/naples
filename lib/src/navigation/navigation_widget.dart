import 'package:flutter/material.dart';
import 'package:naples/src/navigation/navigation.dart';
import 'package:provider/provider.dart';

class NavigationWidget extends StatelessWidget {
  NavigationWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currentStateViewModel = context.select<NavigationModel, StateViewModel>(
      (value) => value.currentStateViewModel,
    );
    if (currentStateViewModel == null) return SizedBox();
    var w = currentStateViewModel.builder(context);
    return w;
  }
}
