import 'package:flutter/material.dart';
import 'package:yellow_naples/view_model.dart';
import 'package:provider/provider.dart';
import '../navigation.dart';

class NavigationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var currentViewModel =
        context.select<NavigationModel, ViewModel>((nm) => nm.currentStateViewModel.viewModel);

    var w = WillPopScope(
        onWillPop: () async {
          try {
            var navigationModel = Provider.of<NavigationModel>(context, listen: false);
            var isBack = await navigationModel.back();
            if (isBack) return false;
            return true;
          } catch (e) {
            return false;
          }
        },
        child: currentViewModel.widget);

    return MultiProvider(providers: [
      ChangeNotifierProvider<ViewModel>.value(value: currentViewModel),
      ChangeNotifierProxyProvider<ViewModel, TitleModel>(
          create: (_) => TitleModel(currentViewModel.title),
          update: (_, viewModel, myTitleModel) => myTitleModel..value = viewModel.title),
    ], child: w);
  }
}

//TODO: Coses que falten:
//1.- Cal fer proves amb altres models de navegació...abstract
//2.- Potser es pot tenir un navigation model que permeti navegar de qualsevol transició a qualsevol altra
