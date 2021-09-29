import 'package:flutter/material.dart';
import 'package:naples/src/navigation/navigation.dart';

class WillPopScopeNavigationWidget extends StatelessWidget {
  final Widget child;
  final NavigationModel navigationModel;
  WillPopScopeNavigationWidget({Key? key, required this.child, required this.navigationModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        try {
          var isBack = navigationModel.back();
          if (isBack) return false;
          return true;
        } catch (e) {
          return false;
        }
      },
      child: child,
    );
  }
}
