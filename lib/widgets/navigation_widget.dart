import 'package:flutter/material.dart';
import 'package:yellow_naples/view_models/view_model.dart';
import 'package:provider/provider.dart';
import 'package:yellow_naples/navigation/navigation.dart';

/// This widget depends on these providers:
/// - NavigationModel
class NavigationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var navigationModel = Provider.of<NavigationModel>(context, listen: false);
    var currentViewModel =
        context.select<NavigationModel, ViewModel>((nm) => nm.currentStateViewModel.viewModel);

    //Creates a key from the enum of the NavigationFlow, needed for the AnimationSwitcher to work
    var k = 0;
    k = navigationModel.currentStateViewModel?.state?.index as int ?? 0;

    //TODO: Maybe the behaviour of stepping back can be configured on the NavigationModel

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
        child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return SlideTransition(
                  child: child,
                  position: Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
                      .animate(CurvedAnimation(curve: Curves.decelerate, parent: animation)));
            },
            child: Container(key: ValueKey(k), child: currentViewModel.widget)));
  }
}
