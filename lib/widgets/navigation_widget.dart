import 'package:flutter/material.dart';
import 'package:yellow_naples/view_models/view_model.dart';
import 'package:provider/provider.dart';
import 'package:yellow_naples/navigation/navigation.dart';

class NavigationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var navigationModel = Provider.of<NavigationModel>(context, listen: false);
    var currentViewModel =
        context.select<NavigationModel, ViewModel>((nm) => nm.currentStateViewModel.viewModel);

    //Creates a key from the enum of the NavigationFlow, needed for the AnimationSwitcher to work
    var k = 0;
    k = navigationModel.currentStateViewModel?.state?.index as int ?? 0;

    var w = WillPopScope(
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

    return MultiProvider(providers: [
      ChangeNotifierProvider<ViewModel>.value(value: currentViewModel),
      ChangeNotifierProxyProvider<ViewModel, TitleModel>(
          create: (_) => TitleModel(currentViewModel.title),
          update: (_, viewModel, myTitleModel) => myTitleModel..value = viewModel.title),
    ], child: w);
  }
}
