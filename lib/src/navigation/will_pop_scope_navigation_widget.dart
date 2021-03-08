import 'package:flutter/material.dart';
import 'package:naples/src/navigation/navigation.dart';
import 'package:provider/provider.dart';

class WillPopScopeNavigationWidget extends StatelessWidget {
  final Widget child;
  WillPopScopeNavigationWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var navigationModel = context.watch<NavigationModel>();
    return WillPopScope(
      onWillPop: () async {
        try {
          var isBack = await navigationModel.back();
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
