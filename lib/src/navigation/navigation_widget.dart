import 'package:flutter/material.dart';
import 'package:naples/src/navigation/navigation.dart';
import 'package:provider/provider.dart';

class NavigationWidget extends StatelessWidget {
  NavigationWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var navigationModel = context.watch<NavigationModel>();
    var currentStateViewModel = navigationModel.currentStateViewModel;

    if (currentStateViewModel == null) return Container();

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

      child: currentStateViewModel.builder(context),
    );
  }
}

//TODO: També caldria canviar la animació, que no funciona prou bé.
